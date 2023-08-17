[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

![Terraform](https://cloudarmy.io/tldr/images/tf_aws.jpg)
<br>
<br>
<br>
<br>
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/adamwshero/terraform-aws-transit-gateway-attachment?color=lightgreen&label=latest%20tag%3A&style=for-the-badge)
<br>
<br>
# terraform-aws-transit-gateway-attachment

Terraform module to create one or many Amazon Transit Gateway Attachments to an existing Amazon Transit Gateway.

[Amazon Transit Gateway (TGW)](https://aws.amazon.com/transit-gateway/) connects your Amazon Virtual Private Clouds (VPCs) and on-premises networks through a central hub. This simplifies your network and puts an end to complex peering relationships. It acts as a cloud router – each new connection is only made once. Attachments to your TGW can be made from any account in your organization to enable cross-account connectivity.

## Module Capabilities
  * Supports (One or Many) of the following:
    * Transit Gateway Attachments 
    * TGW Routes
    * NAT Gateway routes
    * Local Gateway routes
    * Network Interface routes
    * VPC Endpoint routes
    * VPC Peering routes


 ## Assumptions
  * VPC Peering
    * VPC peers are already in place. This is because when we create routes in the route table(s), we need to already know the peering Id to create this route.
  * Transit Gateway
    * A transit gateway already exists somewhere in the AWS Organization. This Id is used when creating transit gateway attachments.

## Usage

You can create a transit gateway attachment for an existing transit gateway in your organization. You can also create multiple transit gateway attachments if you have more than one transit gateway in your organization that you need to attach in a given account.

### Terraform Basic Example

```
module "transit_gateway_attachment" {
  source  = "adamwshero/transit-gateway-attachment/aws"
  version = "~> 1.5.0"

  transit_gateway_attachments = {
    attachment-1 = {
      vpc_id             = dependency.vpc.outputs.vpc_id
      transit_gateway_id = local.account.locals.tgw_id_1
      subnet_ids         = dependency.vpc.outputs.private_subnets
    }
  }
  transit_gateway_routes = {
    "private_rtb" = {
      route_table_ids         = dependency.vpc.outputs.private_route_table_ids
      destination_cidr_blocks = ["${local.common.cidr-1}", "${local.common.cidr-2}"]
      transit_gateway_id      = local.external_deps.dependency.settings.outputs.settings.transit_gateway_id
    }
  }
  vpc_peering_routes = {
    "private_pcx" = {
      route_table_ids           = dependency.vpc.outputs.private_route_table_ids
      destination_cidr_blocks   = ["${local.common.vpc-peer-cidr-1}"]
      vpc_peering_connection_id = "${local.common.pcx-1}"
    }
  }

  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
```

### Terragrunt Basic Example

```
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
  }
  transit_gateway_routes = {
    "private_rtb" = {
      route_table_ids         = dependency.vpc.outputs.private_route_table_ids
      destination_cidr_blocks = ["${local.common.cidr-1}", "${local.common.cidr-2}"]
      transit_gateway_id      = local.external_deps.dependency.settings.outputs.settings.transit_gateway_id
    }
  }
  vpc_peering_routes = {
    "private_pcx" = {
      route_table_ids           = dependency.vpc.outputs.private_route_table_ids
      destination_cidr_blocks   = ["${local.common.vpc-peer-cidr-1}"]
      vpc_peering_connection_id = "${local.common.pcx-1}"
    }
  }

  tags = local.tags
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 
| <a name="requirement_terragrunt"></a> [terragrunt](#requirement\_terragrunt) | >= 0.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.rsm](https://registry.terraform.io/providers/aaronfeng/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource
| [aws_route.rsm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource


## Available Inputs

| Name                        | Resource                               |  Variable                                         | Data Type      | Default   | Required?
| --------------------------- | ---------------------------------------|---------------------------------------------------|----------------|-----------|----------
| Create TGW Attachment       | aws_ec2_transit_gateway_vpc_attachment | `create_attachment`                               | `bool`         | `true`    | Yes
| VPC Id                      | aws_ec2_transit_gateway_vpc_attachment | `vpc_id`                                          | `string`       | `""`      | Yes
| Subnet Ids                  | aws_ec2_transit_gateway_vpc_attachment | `subnet_ids`                                      | `list(string)` | `[""]`    | Yes
| Transit Gateway Id          | aws_ec2_transit_gateway_vpc_attachment | `transit_gateway_id`                              | `string`       | `true`    | Yes
| Appliance Mode Support      | aws_ec2_transit_gateway_vpc_attachment | `appliance_mode_support`                          | `string`       | `disable` | No
| DNS Support                 | aws_ec2_transit_gateway_vpc_attachment | `dns_support`                                     | `string`       | `enable`  | No
| IPv6 Support                | aws_ec2_transit_gateway_vpc_attachment | `ipv6_support`                                    | `string`       | `disable` | No
| Route Table Association     | aws_ec2_transit_gateway_vpc_attachment | `transit_gateway_default_route_table_association` | `bool`         | `true`    | No
| Route Table Propogation     | aws_ec2_transit_gateway_vpc_attachment | `transit_gateway_default_route_table_propogation` | `bool`         | `true`    | No
| Tags                        | aws_ec2_transit_gateway_vpc_attachment | `tags`                                            | `map(string)`  | `None`    | No
| Transit Gateway Attachments | aws_ec2_transit_gateway_vpc_attachment | `transit_gateway_attachments`                     | `map(any)`     | ``        | No
| Transit Gateway Routes      | aws_route                              | `transit_gateway_routes`                          | `map(any)`     | ``        | No
| VPC Peering Routes          | aws_route                              | `vpc_peering_routes`                              | `map(any)`     | ``        | No
| NAT Gateway Routes          | aws_route                              | `nat_gateway_routes`                              | `map(any)`     | ``        | No
| Local Gateway Routes        | aws_route                              | `local_gateway_routes`                            | `map(any)`     | ``        | No
| Network Interface Routes    | aws_route                              | `network_interface_routes`                        | `map(any)`     | ``        | No
| VPC Endpoint Routes         | aws_route                              | `vpc_endpoint_routes`                             | `map(any)`     | ``        | No

## Predetermined Inputs

| Name                        | Resource                               |  Property                     | Data Type    | Default                 | Required?
| ----------------------------| ---------------------------------------|-------------------------------| -------------|-------------------------|----------
| - | - | - | - | - | -


## Outputs

| Name                        | Description                         |
|-----------------------------|-------------------------------------|
| Transit Gateway Attachments | map(list(map)) of your attachments. |
| Transit Gateway Route Ids   | map(list(map)) of your routes Ids.  |
