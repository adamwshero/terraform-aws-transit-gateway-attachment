locals {
  env        = "dev"
  account_id = "12345679810"
  vpc_id     = "vpc-1234ab567"
  tgw_id_1   = "tgw-1111a11111a1a1aa1"
  tgw_id_2   = "tgw-2222a22222a2a2aa2"
  subnet_ids = ["10.26.0.0/19", "10.26.32.0/19", "10.26.64.0/19"]
}

module "transit_gateway_attachment" {
  source  = "adamwshero/transit-gateway-attachment/aws"
  version = "~> 1.0.0"

  transit_gateway_attachments = {
    attachment-1 = {
      vpc_id             = local.vpc_id
      transit_gateway_id = local.tgw_id_1
      subnet_ids         = local.subnet_ids
    }
    attachment-2 = {
      vpc_id             = local.vpc_id
      transit_gateway_id = local.tgw_id_2
      subnet_ids         = local.subnet_ids
    }
  }
  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
