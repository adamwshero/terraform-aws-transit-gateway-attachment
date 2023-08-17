# Complete Plan Example 

```
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
  source = "git@github.com:adamwshero/terraform-aws-transit-gateway-attachment//.?ref=1.5.0"
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
  tags = local.tags
}
```