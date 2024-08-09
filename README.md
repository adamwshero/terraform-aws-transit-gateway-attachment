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

<!-- BEGIN_TF_DOCS -->
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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_peering_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_peering_attachment) | resource |
| [aws_ec2_transit_gateway_peering_attachment_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_peering_attachment_accepter) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route.this_local_gateway_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.this_nat_gateway_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.this_network_interface_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.this_tgw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.this_vpc_endpoint_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.this_vpc_peering_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appliance_mode_support"></a> [appliance\_mode\_support](#input\_appliance\_mode\_support) | (Optional) Whether Appliance Mode support is enabled. If enabled, a traffic flow between a source and destination uses the same Availability Zone for the VPC attachment for the lifetime of that flow. Valid values: `disable`, `enable`. Default value: `disable`. | `string` | `"disable"` | no |
| <a name="input_create_attachment"></a> [create\_attachment](#input\_create\_attachment) | Determines whether to create tgw attachment or not. | `bool` | `true` | no |
| <a name="input_create_peering_attachment"></a> [create\_peering\_attachment](#input\_create\_peering\_attachment) | Determines whether to create a tgw peering attachment or not. | `bool` | `false` | no |
| <a name="input_create_peering_attachment_accepter"></a> [create\_peering\_attachment\_accepter](#input\_create\_peering\_attachment\_accepter) | Determines whether to create a tgw peering attachment or not. | `bool` | `false` | no |
| <a name="input_dns_support"></a> [dns\_support](#input\_dns\_support) | (Optional) Whether DNS support is `enabled`. Valid values: `disable`, `enable`. Default value: `enable`. | `string` | `"enable"` | no |
| <a name="input_ipv6_support"></a> [ipv6\_support](#input\_ipv6\_support) | (Optional) Whether IPv6 support is `enabled`. Valid values: `disable`, `enable`. Default value: `disable`. | `string` | `"disable"` | no |
| <a name="input_local_gateway_routes"></a> [local\_gateway\_routes](#input\_local\_gateway\_routes) | Map of objects that define the local gateway routes to be created | `any` | `{}` | no |
| <a name="input_nat_gateway_routes"></a> [nat\_gateway\_routes](#input\_nat\_gateway\_routes) | Map of objects that define the nat gateway routes to be created | `any` | `{}` | no |
| <a name="input_network_interface_routes"></a> [network\_interface\_routes](#input\_network\_interface\_routes) | Map of objects that define the network interface routes to be created | `any` | `{}` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | (Required) Identifiers of EC2 Subnets. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Key-value tags for the EC2 Transit Gateway VPC Attachment. If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | n/a | yes |
| <a name="input_transit_gateway_attachments"></a> [transit\_gateway\_attachments](#input\_transit\_gateway\_attachments) | Map of objects that define the transit gateway attachments to be created | `any` | `{}` | no |
| <a name="input_transit_gateway_default_route_table_association"></a> [transit\_gateway\_default\_route\_table\_association](#input\_transit\_gateway\_default\_route\_table\_association) | (Optional) Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways. Default value: `true`. | `bool` | `true` | no |
| <a name="input_transit_gateway_default_route_table_propagation"></a> [transit\_gateway\_default\_route\_table\_propagation](#input\_transit\_gateway\_default\_route\_table\_propagation) | (Optional) Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways. Default value: `true`. | `bool` | `true` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | (Required) Identifier of EC2 Transit Gateway. | `string` | `""` | no |
| <a name="input_transit_gateway_peering_attachments"></a> [transit\_gateway\_peering\_attachments](#input\_transit\_gateway\_peering\_attachments) | Map of objects that define the transit gateway peering attachments to be created | `any` | `{}` | no |
| <a name="input_transit_gateway_routes"></a> [transit\_gateway\_routes](#input\_transit\_gateway\_routes) | Map of objects that define the transit gateway routes to be created | `any` | `{}` | no |
| <a name="input_vpc_endpoint_routes"></a> [vpc\_endpoint\_routes](#input\_vpc\_endpoint\_routes) | Map of objects that define the nat gateway routes to be created | `any` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) Identifier of EC2 VPC. | `string` | `""` | no |
| <a name="input_vpc_peering_routes"></a> [vpc\_peering\_routes](#input\_vpc\_peering\_routes) | Map of objects that define the vpc peering routes to be created | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_transit_gateway_attachments"></a> [transit\_gateway\_attachments](#output\_transit\_gateway\_attachments) | Map of transit gateway attachments. |
| <a name="output_transit_gateway_route_ids"></a> [transit\_gateway\_route\_ids](#output\_transit\_gateway\_route\_ids) | The IDs of the created routes. |
<!-- END_TF_DOCS -->