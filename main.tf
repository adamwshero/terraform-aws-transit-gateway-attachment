locals {
  tgw_routes = distinct(flatten([
    for k, v in var.transit_gateway_routes : [
      for destination_cidr_block in v.destination_cidr_blocks : [
        for route_table_id in v.route_table_ids : {
          route_table_id         = route_table_id
          destination_cidr_block = destination_cidr_block
          transit_gateway_id     = v.transit_gateway_id
        }
      ]
    ]
  ]))
  vpc_peering_routes = distinct(flatten([
    for k, v in var.vpc_peering_routes : [
      for destination_cidr_block in v.destination_cidr_blocks : [
        for route_table_id in v.route_table_ids : {
          route_table_id            = route_table_id
          destination_cidr_block    = destination_cidr_block
          vpc_peering_connection_id = v.vpc_peering_connection_id
        }
      ]
    ]
  ]))
  nat_gateway_routes = distinct(flatten([
    for k, v in var.nat_gateway_routes : [
      for destination_cidr_block in v.destination_cidr_blocks : [
        for route_table_id in v.route_table_ids : {
          route_table_id         = route_table_id
          destination_cidr_block = destination_cidr_block
          nat_gateway_id         = v.nat_gateway_id
        }
      ]
    ]
  ]))
  local_gateway_routes = distinct(flatten([
    for k, v in var.local_gateway_routes : [
      for destination_cidr_block in v.destination_cidr_blocks : [
        for route_table_id in v.route_table_ids : {
          route_table_id         = route_table_id
          destination_cidr_block = destination_cidr_block
          local_gateway_id       = v.local_gateway_id
        }
      ]
    ]
  ]))
  network_interface_routes = distinct(flatten([
    for k, v in var.network_interface_routes : [
      for destination_cidr_block in v.destination_cidr_blocks : [
        for route_table_id in v.route_table_ids : {
          route_table_id         = route_table_id
          destination_cidr_block = destination_cidr_block
          network_interface_id   = v.network_interface_id
        }
      ]
    ]
  ]))
  vpc_endpoint_routes = distinct(flatten([
    for k, v in var.vpc_endpoint_routes : [
      for destination_cidr_block in v.destination_cidr_blocks : [
        for route_table_id in v.route_table_ids : {
          route_table_id         = route_table_id
          destination_cidr_block = destination_cidr_block
          vpc_endpoint_id        = v.vpc_endpoint_id
        }
      ]
    ]
  ]))
}
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = { for k, v in var.transit_gateway_attachments : k => v if var.create_attachment }

  vpc_id                 = each.value.vpc_id
  subnet_ids             = each.value.subnet_ids
  transit_gateway_id     = each.value.transit_gateway_id
  appliance_mode_support = var.appliance_mode_support
  dns_support            = var.dns_support
  ipv6_support           = var.ipv6_support

  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation

  tags = merge(
    var.tags,
    tomap({ "Name" = each.key })
  )
}

resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  for_each = { for k, v in var.transit_gateway_peering_attachments : k => v if var.create_peering_attachment }

  peer_account_id         = each.value.peer.account_id
  peer_region             = each.value.peer.region
  peer_transit_gateway_id = each.value.peer.transit_gateway_id
  transit_gateway_id      = each.value.transit_gateway_id

  tags = merge(
    var.tags,
    tomap({ "Name" = each.key })
  )
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "this" {

  for_each = { for k, v in var.transit_gateway_peering_attachments_accepter : k => v if var.create_peering_attachment_accepter }

  transit_gateway_attachment_id = each.value.transit_gateway_attachment_id

  tags = merge(
    var.tags,
    tomap({ "Name" = each.key })
  )
}

resource "aws_route" "this_tgw_route" {
  for_each = { for route in local.tgw_routes : "${route.route_table_id}.${route.destination_cidr_block}.${route.transit_gateway_id}" => route }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  transit_gateway_id     = each.value.transit_gateway_id
}

resource "aws_route" "this_vpc_peering_route" {
  for_each = { for route in local.vpc_peering_routes : "${route.route_table_id}.${route.destination_cidr_block}.${route.vpc_peering_connection_id}" => route }

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.destination_cidr_block
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
}

resource "aws_route" "this_nat_gateway_route" {
  for_each = { for route in local.nat_gateway_routes : "${route.route_table_id}.${route.destination_cidr_block}.${route.nat_gateway_id}" => route }

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = each.value.destination_cidr_block
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
}

resource "aws_route" "this_local_gateway_route" {
  for_each = { for route in local.local_gateway_routes : "${route.route_table_id}.${route.destination_cidr_block}.${route.local_gateway_id}" => route }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  local_gateway_id       = each.value.local_gateway_id
}

resource "aws_route" "this_network_interface_route" {
  for_each = { for route in local.network_interface_routes : "${route.route_table_id}.${route.destination_cidr_block}.${route.network_interface_id}" => route }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  network_interface_id   = each.value.network_interface_id
}

resource "aws_route" "this_vpc_endpoint_route" {
  for_each = { for route in local.vpc_endpoint_routes : "${route.route_table_id}.${route.destination_cidr_block}.${route.vpc_endpoint_id}" => route }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  vpc_endpoint_id        = each.value.vpc_endpoint_id
}
