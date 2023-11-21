# iam_role/outputs.tf

output "lambda_execution_role" {
  value = aws_iam_role.lambda_execution_role
}
