resource "aws_api_gateway_resource" "proxy" {
  parent_id   = aws_api_gateway_rest_api.site.root_resource_id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.site.id
}

module "options_proxy" {
  source = "github.com/jdhollis/api-gateway-options"

  allow_headers = "'content-type,authorization,x-amz-date,x-api-key,x-amz-security-token,x-csrf-token'"
  allow_methods = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
  allow_origin  = var.allow_origin_override != "" ? var.allow_origin_override : "https://${var.domain}"
  resource_id   = aws_api_gateway_resource.proxy.id
  rest_api_id   = aws_api_gateway_rest_api.site.id
}

resource "aws_api_gateway_method" "proxy" {
  authorization = "NONE"
  http_method   = "ANY"

  request_parameters = {
    "method.request.path.proxy" = true
  }

  resource_id = aws_api_gateway_resource.proxy.id
  rest_api_id = aws_api_gateway_rest_api.site.id
}

resource "aws_api_gateway_integration" "proxy" {
  connection_id           = module.query_group.vpc_link_id
  connection_type         = "VPC_LINK"
  http_method             = "ANY"
  integration_http_method = "ANY"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  resource_id = aws_api_gateway_resource.proxy.id
  rest_api_id = aws_api_gateway_rest_api.site.id
  type        = "HTTP_PROXY"
  uri         = "${module.query_group.load_balancer_http_direct_endpoint}/{proxy}"
}
