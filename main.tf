# Download any stable version in AWS provider of 2.19.0 or higher in 2.19 train
provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "assume_role"
  region = "eu-west-2"
  assume_role {
    role_arn = aws_iam_role.assume_role.arn
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "assume_role" {
  name             = "AssumedRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

module "lambda" {
  source = "./chatbotterraform/lambda"
  # Add other Lambda configuration options as needed
}

module "lex_bot" {
  source        = "./chatbotterraform/lex"
  lambda_arn    = module.lambda.lambda_arn  # Check if lambda module is defined
  # Add other configuration options as needed
}

module "ecs" {
  source = "./chatbotterraform/ecs"
  # Add ECS configuration options as needed
}

module "ec2" {
  source = "./chatbotterraform/ec2"
  # Add EC2 configuration options as needed
}

module "iam_role" {
  source = "./chatbotterraform/iam_role"
}

module "iam_role_policy" {
  source   = "./chatbotterraform/iam_role_policy"
  role_arn = aws_iam_role.assume_role.arn  # Use the ARN of the assumed role
}

# Add the following block to export temporary credentials
output "temporary_credentials" {
  value = {
    aws_access_key     = aws_iam_role.assume_role.arn
    aws_secret_key     = aws_iam_role.assume_role.arn
    aws_session_token  = aws_iam_role.assume_role.arn
  }
}
