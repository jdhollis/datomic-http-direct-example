terraform {
  required_version = "~> 0.12.0"

  backend "s3" {
    encrypt = true
  }
}

provider "aws" {
  version = "~> 2.31"
  region  = var.region
  profile = var.profile

  assume_role {
    role_arn = var.assume_role_arn
  }
}

resource "aws_api_gateway_rest_api" "site" {
  name               = "Site API${var.suffix == "" ? "" : " ${var.suffix}"}"
  binary_media_types = ["*/*"]
}

locals {
  dependency_hashes = [
    md5(file("${path.module}/proxy.tf")),
  ]

  combined_hash = md5(join("\n", local.dependency_hashes))
}

resource "aws_api_gateway_deployment" "site" {
  depends_on = [
    aws_api_gateway_integration.proxy,
    module.options_proxy.id,
  ]

  rest_api_id       = aws_api_gateway_rest_api.site.id
  stage_name        = var.env
  stage_description = local.combined_hash
}

resource "aws_api_gateway_method_settings" "site" {
  method_path = "*/*"
  rest_api_id = aws_api_gateway_rest_api.site.id

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
  }

  stage_name = aws_api_gateway_deployment.site.stage_name
}

module "query_group" {
  source = "./datomic"

  allow_origin        = var.allow_origin_override != "" ? var.allow_origin_override : "https://${var.domain}"
  assume_role_arn     = var.assume_role_arn
  database_name       = var.database_name
  env                 = var.env
  query_group_cfs_url = "https://s3.amazonaws.com/datomic-cloud-1/cft/535-8812/datomic-query-group-535-8812.json"
  region              = var.region
  rev                 = var.rev
  suffix              = var.suffix
}
