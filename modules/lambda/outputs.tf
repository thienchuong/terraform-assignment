output "lambda_arn" {
  value = aws_lambda_function.this.arn
}

output "lambda_version" {
  value = aws_lambda_function.this.version
}

output "lambda_name" {
  value = var.function_name
}