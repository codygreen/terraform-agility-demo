#
# Set minimum Terraform version and Terraform Cloud backend
#
terraform {
  required_version = ">= 0.12"
}

#
# Configure AWS provider
#
provider "aws" {
  region = var.region
  # access_key = var.AccessKeyID
  # secret_key = var.SecretAccessKey
}

#
# Create a random id
#
resource "random_id" "id" {
  byte_length = 2
}

#
# Create the SSH Key
#
resource "tls_private_key" "aws" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.ec2_key_name
  public_key = tls_private_key.aws.public_key_openssh
}

resource "local_file" "ssh_udf" {
  content         = tls_private_key.aws.private_key_pem
  filename        = format("%s/udf.pem", path.module)
  file_permission = "0600"
}

#
# Create the VPC 
#
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = format("%s-vpc-%s", var.prefix, random_id.id.hex)
  cidr                 = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs = var.azs

  public_subnets = [
    for num in range(length(var.azs)) :
    cidrsubnet(var.cidr, 8, num)
  ]

  private_subnets = [
    for num in range(length(var.azs)) :
    cidrsubnet(var.cidr, 8, num + 10)
  ]

  enable_nat_gateway = true

  tags = {
    Name        = format("%s-vpc-%s", var.prefix, random_id.id.hex)
    Terraform   = "true"
    Environment = "dev"
  }
}

#
# Create a security group for BIG-IP
#
module "bigip_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-bigip-%s", var.prefix, random_id.id.hex)
  description = "Security group for BIG-IP Demo"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.allowed_app_cidr]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.bigip_sg.this_security_group_id
    }
  ]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

#
# Create a security group for BIG-IP Management
#
module "bigip_mgmt_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-bigip-mgmt-%s", var.prefix, random_id.id.hex)
  description = "Security group for BIG-IP Demo"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.allowed_mgmt_cidr]
  ingress_rules       = ["https-443-tcp", "https-8443-tcp", "ssh-tcp"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.bigip_mgmt_sg.this_security_group_id
    }
  ]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

#
# Create a security group for demo app
#
module "demo_app_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-demo-app-%s", var.prefix, random_id.id.hex)
  description = "Security group for BIG-IP Demo"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.cidr]
  ingress_rules       = ["all-all"]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}


#
# Create the demo NGINX app
#
module "nginx-demo-app" {
  source  = "codygreen/nginx-demo-app/aws"
  version = "0.1.2"

  prefix = format(
    "%s-%s",
    var.prefix,
    random_id.id.hex
  )
  ec2_key_name = var.ec2_key_name
  # associate_public_ip_address = true
  vpc_security_group_ids = [
    module.demo_app_sg.this_security_group_id
  ]
  vpc_subnet_ids     = module.vpc.private_subnets
  ec2_instance_count = 4
}

#
# Create the BIG-IP appliances
#
module "bigip" {
  source  = "f5devcentral/bigip/aws"
  version = "0.1.1"

  prefix = format(
    "%s-bigip-1-nic_with_new_vpc-%s",
    var.prefix,
    random_id.id.hex
  )
  f5_instance_count = length(var.azs)
  ec2_key_name      = var.ec2_key_name
  ec2_instance_type = "m4.large"
  mgmt_subnet_security_group_ids = [
    module.bigip_sg.this_security_group_id,
    module.bigip_mgmt_sg.this_security_group_id
  ]
  vpc_mgmt_subnet_ids = module.vpc.public_subnets
  f5_ami_search_name  = var.f5_ami_search_name
  AS3_URL             = var.as3_url
  DO_URL              = var.do_url
}
