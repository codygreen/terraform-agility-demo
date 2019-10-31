# Terraform Agility Demo
Deploy the Agility Basic Deployment Pattern using Terraform

# Setup
1. You need to store the AWS Secret Key Access Token in the Shared Credentials file.
2. Accept the Market Place offer for the [BIG-IP AMI] (https://aws.amazon.com/marketplace/server/procurement?productId=929ca0d8-c2d7-4068-8f9a-eb75a677afed)
3. Deploy the lab via Terraform:
```hcl 
terraform init
terraform apply
```