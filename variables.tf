variable "region" {
  type = string
    default = "ap-southeast-2"
}


variable "lists_of_routes" {
  type = list(object({
  source_dir = string
  object_key = string
  name = string
  handler = string
  integration_method = string
  route_key = string
  passthrough_behavior = string
  }))

  default = [
    {
      source_dir = "api/fallback"
      object_key = "fallback.zip"
      name = "Fallback"
      handler = "index.handler"
      integration_method = "POST"
      route_key = "GET /{proxy+}"
      passthrough_behavior = "WHEN_NO_MATCH"

    },
    {
      source_dir = "api/hello/GET"
      object_key = "hello-world.zip"
      name = "HelloWorld"
      handler = "index.handler"
      integration_method = "POST"
      route_key = "GET /hello"
      passthrough_behavior = "NEVER"
    }
  ]
}