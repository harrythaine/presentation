# chatbotterraform/lambda/main.tf

module "iam_role" {
  source = "../iam_role"
}

module "iam_role_policy" {
  source   = "../iam_role_policy"
  role_arn = module.iam_role.lambda_execution_role.arn
}

resource "aws_lambda_function" "chatbot_lambda" {
  function_name = "chatbotLambda"
  role          = module.iam_role.lambda_execution_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"
  filename      = "./lambda/main.zip"

  # Comment out the environment block for now
  # environment = {
  #   variables = {
  #     LEX_BOT_NAME = "htbBot"
  #   }
  # }
}
