variable "bucket_name" {
  type = string
}

variable "lambda_exec_arn" {
  type = string
}


variable "source_dir" {
  type = string
}

variable "object_key" {
  type = string
}

variable "name" {
  type = string
}

variable "handler" {
  type = string
}

variable "gw_id" {
  type = string
}

variable "gw_execution_arn" {
  type = string
}

variable "integration_method" {
  type = string
}

variable "route_key" {
  type = string
}

variable "passthrough_behavior" {
  type = string
}