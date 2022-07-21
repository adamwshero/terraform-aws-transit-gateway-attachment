locals {
  account     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  product     = read_terragrunt_config(find_in_parent_folders("product.hcl"))
  environment = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  tags = merge(
    local.product.locals.tags,
    local.additional_tags
  )
  additional_tags = {
  }
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "git@github.com:adamwshero/terraform-aws-transit-gateway-attachment//.?ref=1.0.0"
}

inputs = {
  transit_gateway_attachments = {
    attachment-1 = {
      vpc_id             = dependency.vpc.outputs.vpc_id
      transit_gateway_id = local.account.locals.tgw_id_1
      subnet_ids         = dependency.vpc.outputs.private_subnets
    }
    attachment-2 = {
      vpc_id             = dependency.vpc.outputs.vpc_id
      transit_gateway_id = local.account.locals.tgw_id_2
      subnet_ids         = dependency.vpc.outputs.private_subnets
    }
  }

  tags = local.tags
}
