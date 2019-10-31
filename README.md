# Terraform Agility Demo
Deploy the Agility Basic Deployment Pattern using Terraform

# Setup
1. You need to store the AWS Secret Key Access Token in the Shared Credentials file.
2. Accept the Market Place offer for the [BIG-IP AMI] (https://aws.amazon.com/marketplace/server/procurement?productId=929ca0d8-c2d7-4068-8f9a-eb75a677afed)
3. Deploy the lab via Terraform:
```hcl 
terraform init
terraform apply -target tls_private_key.aws -target aws_key_pair.generated_key -target local_file.ssh_udf -target module.vpc -target module.nginx-demo-app -target module.bigip -target module.bigip_sg -target module.bigip_mgmt_sg -target module.demo_app_sg -target aws_secretsmanager_secret_version.bigip-pwd
terraform apply
```