# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "LambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com",
      },
    }],
  })
}

# IAM Role policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "LambdaPolicy"
  role = aws_iam_role.lambda_execution_role.id  # Use the role's id here

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

# Lambda function
resource "aws_lambda_function" "chatbot_lambda" {
  function_name = "chatbotLambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"
  filename      = "./lambda/main.zip"  # Path to your Lambda deployment package
 environment = {
    variables = {
      LEX_BOT_NAME = "htbBot"
      # Add other environment variables as needed
    }
  }
}


# Attach IAM policy to role
resource "aws_iam_role_policy_attachment" "test-attach" {
  policy_arn = aws_iam_role_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}
