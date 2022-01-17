
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "s3" {
  source = "./modules/s3"
}

module "gw" {
  source = "./modules/gateway"
}

module "iam" {
  source = "./modules/iam"
}


module "lambda" {
  source = "./modules/lambda"

  for_each = {for func in var.lists_of_routes:  func.name => func}
  bucket_name = module.s3.bucket_name
  lambda_exec_arn = module.iam.lambda_exec
  source_dir = "${each.value.source_dir}"
  object_key = "${each.value.object_key}"
  name = "${each.value.name}"
  handler = "${each.value.handler}"
  integration_method = "${each.value.integration_method}"
  route_key = "${each.value.route_key}"
  passthrough_behavior = "${each.value.passthrough_behavior}"
  gw_id = module.gw.id
  gw_execution_arn = module.gw.execution_arn
}
