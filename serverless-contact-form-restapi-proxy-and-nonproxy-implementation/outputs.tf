output "frontend_website_url" {
  description = "URL of the frontend website"
  value       = "http://${aws_s3_bucket.frontend.bucket}.s3-website.${var.aws_region}.amazonaws.com"
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function (needed for API Gateway setup)"
  value       = aws_lambda_function.contact_form.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.contact_form.function_name
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.contact_submissions.name
}