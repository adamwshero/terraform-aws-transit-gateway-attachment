output "transit_gateway_attachments" {
  description = "Map of transit gateway attachments."
  value = {
    for transit_gateway_attachments in keys(var.transit_gateway_attachments) :
    transit_gateway_attachments => aws_ec2_transit_gateway_vpc_attachment.this[transit_gateway_attachments].* [0].*
  }
}

output "transit_gateway_route_ids" {
  description = "The IDs of the created routes."
  value       = concat(values(aws_route.this_tgw_route)[*].id, values(aws_route.this_vpc_peering_route)[*].id, values(aws_route.this_nat_gateway_route)[*].id, values(aws_route.this_local_gateway_route)[*].id, values(aws_route.this_network_interface_route)[*].id, values(aws_route.this_vpc_endpoint_route)[*].id)
}
