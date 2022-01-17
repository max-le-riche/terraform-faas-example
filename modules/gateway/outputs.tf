output "id" {
  value = aws_apigatewayv2_api.lambda.id
}

output "execution_arn" {
  value = aws_apigatewayv2_api.lambda.execution_arn
}

output "api_url" {
  value = aws_apigatewayv2_stage.lambda.invoke_url
}