variable "lambda_environment" {
  type = map(string)
}


resource "aws_lambda_function" "chatbot_lambda" {
  function_name = "chatbotLambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"
  filename      = "./lambda/main.zip"  # Path to your Lambda deployment package

  dynamic "environment" {
    for_each = var.lambda_environment

    content {
      variables = {
        "${environment.key}" = environment.value
      }
    }
  }
}





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

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "LambdaPolicy"
  role   = aws_iam_role.lambda_role.id

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

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

output "lambda_arn" {
  value = aws_lambda_function.chatbot_lambda.arn
}
