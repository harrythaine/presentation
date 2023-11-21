# iam_role_policy/main.tf

variable "role_arn" {
  description = "The ARN of the IAM role"
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "LambdaPolicy"
  role = var.role_arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lex:*",
      "Resource": "*"
    }
  ]
}
POLICY
}

# The policy attachment resource is no longer needed in this module
