//--------------------------------------------------------------------
// Modules
module "bigip_demo" {
  source  = "app.terraform.io/f5cloudsa/bigip-demo/aws"
  version = "0.1.1"

  AccessKeyID     = "${var.bigip_demo_AccessKeyID}"
  ec2_key_name    = "${var.bigip_demo_ec2_key_name}"
  region          = "us-east-2"
  SecretAccessKey = "${var.bigip_demo_SecretAccessKey}"
}
