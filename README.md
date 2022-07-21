[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

![Terraform](https://cloudarmy.io/tldr/images/tf_aws.jpg)
<br>
<br>
<br>
<br>
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/adamwshero/terraform-aws-kms?color=lightgreen&label=latest%20tag%3A&style=for-the-badge)
<br>
<br>
# terraform-aws-transit-gateway-attachment

Terraform module to create one or many Amazon Transit Gateway Attachments to an existing Amazon Transit Gateway.

[Amazon Transit Gateway (TGW)](https://aws.amazon.com/transit-gateway/) connects your Amazon Virtual Private Clouds (VPCs) and on-premises networks through a central hub. This simplifies your network and puts an end to complex peering relationships. It acts as a cloud router – each new connection is only made once. Attachments to your TGW can be made from any account in your organization to enable cross-account connectivity.

## Examples

Look at our [Terraform example](latest/examples/terraform/) where you can get a better context of usage for both Terraform. The Terragrunt example can be viewed directly from GitHub.


## Usage

You can create a transit gateway attachment for an existing transit gateway in your organization. You can also create multiple transit gateway attachments if you have more than one transit gateway in your organization that you need to attach in a given account.

### Terraform Example with multiple TGW attachment use-case.

```
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
```

### Terragrunt Example with multiple TGW attachment use-case.

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
| [aws_ec2_transit_gateway_vpc_attachment.rsm](https://registry.terraform.io/providers/aaronfeng/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment)


## Available Inputs

| Name                   | Resource                              |  Variable                                         | Data Type      | Default   | Required?
| -----------------------| --------------------------------------|---------------------------------------------------|----------------|-----------|----------
| Create TGW Attachment  | aws_ec2_transit_gateway_vpc_attachment| `create_attachment`                               | `bool`         | `true`    | Yes
| VPC Id                 | aws_ec2_transit_gateway_vpc_attachment| `vpc_id`                                          | `string`       | `""`      | Yes
| Subnet Ids             | aws_ec2_transit_gateway_vpc_attachment| `subnet_ids`                                      | `list(string)` | `[""]`    | Yes
| Transit Gateway Id     | aws_ec2_transit_gateway_vpc_attachment| `transit_gateway_id`                              | `string`       | `true`    | Yes
| Appliance Mode Support | aws_ec2_transit_gateway_vpc_attachment| `appliance_mode_support`                          | `string`       | `disable` | No
| DNS Support            | aws_ec2_transit_gateway_vpc_attachment| `dns_support`                                     | `string`       | `enable`  | No
| IPv6 Support           | aws_ec2_transit_gateway_vpc_attachment| `ipv6_support`                                    | `string`       | `disable` | No
| Route Table Association| aws_ec2_transit_gateway_vpc_attachment| `transit_gateway_default_route_table_association` | `bool`         | `true`    | No
| Route Table Propogation| aws_ec2_transit_gateway_vpc_attachment| `transit_gateway_default_route_table_association` | `bool`         | `true`    | No
| Tags                   | aws_ec2_transit_gateway_vpc_attachment| `tags`                                            | `map(string)`  | `None`    | No

## Predetermined Inputs

| Name                        | Resource                               |  Property                     | Data Type    | Default                 | Required?
| ----------------------------| ---------------------------------------|-------------------------------| -------------|-------------------------|----------
| - | - | - | - | - | -


## Outputs

| Name                        | Description                         |
|-----------------------------|-------------------------------------|
|Transit Gateway Attachments | map(list(map)) of your attachments. |
