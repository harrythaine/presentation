# lambda/variables.tf


variable "lambda_environment" {
  type        = map(string)
  description = "Environment variables for the Lambda function."
  default     = {}
}