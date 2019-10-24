//--------------------------------------------------------------------
// Modules
module "bigip_demo" {
  source  = "app.terraform.io/f5cloudsa/bigip-demo/aws"
  version = "0.1.1"

  AccessKeyID     = "${AccessKeyID}"
  ec2_key_name    = "${ec2_key_name}"
  region          = "us-east-2"
  SecretAccessKey = "${SecretAccessKey}"
}
