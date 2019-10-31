# variable "AccessKeyID" {}

# variable "SecretAccessKey" {}

variable "prefix" {
  description = "resource prefix"
  default     = "tf-aws-bigip"
}

variable "region" {
  description = "AWS Region to deploy in. Note: UDF only supports us-west-2"
  default     = "us-west-2"
}

variable "azs" {
  description = "list of availability zones to deploy into"
  default     = ["us-west-2a", "us-west-2b"]
}

variable "cidr" {
  description = "default VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "allowed_mgmt_cidr" {
  description = "CIDR block to allow management traffic from"
  default     = "0.0.0.0/0"
}

variable "allowed_app_cidr" {
  description = "CIDR block to allow application traffic from"
  default     = "0.0.0.0/0"
}

variable "ec2_key_name" {
  description = "AWS EC2 SSH Key Name"
  default     = "udf"
}

variable "f5_ami_search_name" {
  description = "EC2 describe image filter to find the BIG-IP AMI"
  default     = "F5*BIGIP-15.0.1-0.0.11 PAYG-Best 1Gbps*"
}

variable "as3_url" {
  description = "URL for the AS3 RPM"
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.15.0/f5-appsvcs-3.15.0-6.noarch.rpm"
}

variable "do_url" {
  description = "URL for the DO RPM"
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.8.0/f5-declarative-onboarding-1.8.0-2.noarch.rpm"
}

