

data "archive_file" "lambda_route_function" {
  type = "zip"
  source_dir  = "${path.root}/${var.source_dir}"
  output_path = "${path.root}/${var.source_dir}/route.zip"
}

resource "aws_s3_bucket_object" "lambda_route_function" {
  bucket = var.bucket_name
  key    = "${var.object_key}"
  source = data.archive_file.lambda_route_function.output_path
  etag = filemd5(data.archive_file.lambda_route_function.output_path)
}

resource "aws_lambda_function" "route_function" {
  function_name = "${var.name}"

  s3_bucket = var.bucket_name
  s3_key    = aws_s3_bucket_object.lambda_route_function.key

  runtime = "nodejs12.x"
  handler = "${var.handler}"

  source_code_hash = data.archive_file.lambda_route_function.output_base64sha256

  role = var.lambda_exec_arn
}

resource "aws_cloudwatch_log_group" "route_function" {
  name = "/aws/lambda/${aws_lambda_function.route_function.function_name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.route_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.gw_execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "route" {
  api_id = var.gw_id

  integration_uri    = aws_lambda_function.route_function.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "${var.integration_method}"
  passthrough_behavior = "${var.passthrough_behavior}"

  lifecycle {
    ignore_changes = [
      passthrough_behavior
    ]
  }

}

resource "aws_apigatewayv2_route" "route" {
  api_id = var.gw_id

  route_key = "${var.route_key}"
  target    = "integrations/${aws_apigatewayv2_integration.route.id}"
}