resource "aws_lambda_function" "chatbot_lambda" {
  function_name = "chatbotLambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"
  filename      = "./lambda/main.zip"  # Path to your Lambda deployment package

  environment = {
    variables = {
      # Add any environment variables needed by your Lambda function
    }
  }
}

# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

output "lambda_arn" {
  value = aws_lambda_function.chatbot_lambda.arn
}
