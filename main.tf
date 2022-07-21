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

  tags = var.tags
}