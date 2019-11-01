#
# Create IAM Role
#

data "aws_iam_policy_document" "tf_role" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tf_role" {
  name               = format("%s-tf-role", var.prefix)
  assume_role_policy = data.aws_iam_policy_document.tf_role.json

}

data "aws_iam_policy_document" "tf_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:GetRole",
      "iam:GetInstanceProfile",
      "iam:TagRole",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:PutRolePolicy",
      "iam:AddRoleToInstanceProfile",
      "iam:ListInstanceProfilesForRole",
      "iam:PassRole",
      "iam:DeleteRolePolicy",
      "iam:GetRolePolicy",
      "secretsmanager:DeleteSecret",
      "secretsmanager:DescribeSecret",
      "secretsmanager:PutSecretValue",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      "arn:aws:iam::*:role/*",
      "arn:aws:iam::*:instance-profile/*",
      aws_secretsmanager_secret.bigip.arn
    ]
  }
}

resource "aws_iam_role_policy" "tf_policy" {
  name   = format("%s-tf-policy", var.prefix)
  role   = aws_iam_role.tf_role.id
  policy = data.aws_iam_policy_document.tf_policy.json
}
