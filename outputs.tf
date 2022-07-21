output "transit_gateway_attachments" {
  description = "Map of transit gateway attachments."
    value = {
        for transit_gateway_attachments in keys(var.transit_gateway_attachments):
          transit_gateway_attachments => aws_ec2_transit_gateway_vpc_attachment.this[transit_gateway_attachments].*[0].*  
  }
}
