locals {
  env                       = "dev"
  region                    = "us-east-1"
  account_id                = "12345679810"
  vpc_id                    = "vpc-1234ab567"
  tgw_id_1                  = "tgw-1111a11111a1a1aa1"
  tgw_id_2                  = "tgw-2222a22222a2a2aa2"
  nat_gateway_id            = "...."
  transit_gateway_id        = "...."
  local_gateway_id          = "...."
  vpc_endpoint_id           = "...."
  vpc_peering_connection_id = "pcx-123456789"
  subnet_ids                = ["10.26.0.0/19", "10.26.32.0/19", "10.26.64.0/19"]
}
module "transit_gateway_attachment" {
  source  = "adamwshero/transit-gateway-attachment/aws"
  version = "~> 1.6.0"

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

  create_peering_attachment          = true
  create_peering_attachment_accepter = true

  transit_gateway_peering_attachments = {
      attachment-1 = {
        peer = {
          account_id         = local.account_id
          region             = local.region
          transit_gateway_id = local.account.locals.tgw_id_2
        },
        transit_gateway_id = local.account.locals.tgw_id_1
      }

  transit_gateway_peering_attachments_accepter = {
      attachment-1 = {
        transit_gateway_attachment_id = local.account.locals.tgw_id_1
      }
    }
  }

  transit_gateway_routes = {
    private_routes = {
      route_table_ids         = dependency.vpc.outputs.private_route_table_ids
      destination_cidr_blocks = [local.external_account_cidrs]
      transit_gateway_id      = local.transit_gateway_id
    }
    public_routes = {
      route_table_ids         = dependency.vpc.outputs.public_route_table_ids
      destination_cidr_blocks = [local.external_account_cidrs]
      transit_gateway_id      = local.transit_gateway_id
    }
  }
  vpc_peering_routes = {
    private_routes = {
      route_table_ids           = dependency.vpc.outputs.private_route_table_ids
      destination_cidr_blocks   = [local.vpc_peering_cidrs]
      vpc_peering_connection_id = local.vpc_peering_connection_id
    },
    public_routes = {
      route_table_ids           = dependency.vpc.outputs.public_route_table_ids
      destination_cidr_blocks   = [local.vpc_peering_cidrs]
      vpc_peering_connection_id = local.vpc_peering_connection_id
    }
  }
  nat_gateway_routes = {
    private_routes = {
      route_table_ids         = dependency.vpc.outputs.private_route_table_ids
      destination_cidr_blocks = [local.nat_gateway_cidrs]
      nat_gateway_id          = local.nat_gateway_id
    },
    public_routes = {
      route_table_ids         = dependency.vpc.outputs.public_route_table_ids
      destination_cidr_blocks = [local.nat_gateway_cidrs]
      nat_gateway_id          = local.nat_gateway_id
    }
  }
  local_gateway_routes = {
    private_routes = {
      route_table_ids         = dependency.vpc.outputs.private_route_table_ids
      destination_cidr_blocks = [local.local_gateway_cidrs]
      local_gateway_id        = local.local_gateway_id
    },
    public_routes = {
      route_table_ids         = dependency.vpc.outputs.public_route_table_ids
      destination_cidr_blocks = [local.local_gateway_cidrs]
      local_gateway_id        = local.local_gateway_id
    }
  }
  vpc_endpoint_routes = {
    private_routes = {
      route_table_ids         = dependency.vpc.outputs.private_route_table_ids
      destination_cidr_blocks = local.vpc_endpoint_routes
      vpc_endpoint_id         = local.vpc_endpoint_id
    },
    public_routes = {
      route_table_ids         = dependency.vpc.outputs.public_route_table_ids
      destination_cidr_blocks = local.vpc_endpoint_routes
      vpc_endpoint_id         = local.vpc_endpoint_id
    }
  }
  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
