#
# Create IAM Role
#

data "aws_iam_user" "udf" {
  user_name = "udf"
}

resource "aws_iam_policy" "policy" {
  name = "tf-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
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
            ],
            "Resource": [
                "arn:aws:iam::*:role/*",
                "arn:aws:iam::*:instance-profile/*",
                "arn:aws:secretsmanager:*:*:secret:*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:CreateSecret",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "tf" {
  name       = "tf-attachment"
  users      = [data.aws_iam_user.udf.user_name]
  policy_arn = aws_iam_policy.policy.arn
}
