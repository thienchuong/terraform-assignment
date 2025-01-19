output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the created VPC."
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "The primary CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC, if assigned."
  value       = aws_vpc.this.ipv6_cidr_block
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with the VPC."
  value       = aws_vpc.this.main_route_table_id
}

output "vpc_default_network_acl_id" {
  description = "The ID of the default network ACL associated with the VPC."
  value       = aws_vpc.this.default_network_acl_id
}

output "vpc_default_security_group_id" {
  description = "The ID of the default security group associated with the VPC."
  value       = aws_vpc.this.default_security_group_id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway, if created."
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway, if created."
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].arn : null
}

output "nat_gateway_ids" {
  description = "A list of IDs of the created NAT Gateways."
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_ips" {
  description = "A list of Elastic IPs associated with the created NAT Gateways."
  value       = aws_eip.nat[*].public_ip
}

output "public_subnet_ids" {
  description = "A list of IDs of the created public subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "A list of IDs of the created private subnets."
  value       = aws_subnet.private[*].id
}

output "public_route_table_ids" {
  description = "A list of IDs of the route tables associated with public subnets."
  value       = aws_route_table.public[*].id
}

output "private_route_table_ids" {
  description = "A list of IDs of the route tables associated with private subnets."
  value       = aws_route_table.private[*].id
}

output "dhcp_options_id" {
  description = "The ID of the DHCP options set, if created."
  value       = length(aws_vpc_dhcp_options.this) > 0 ? aws_vpc_dhcp_options.this[0].id : null
}

output "secondary_cidr_blocks" {
  description = "A list of secondary CIDR blocks associated with the VPC."
  value       = aws_vpc_ipv4_cidr_block_association.this[*].cidr_block
}

output "azs" {
  description = "The availability zones used for the VPC subnets."
  value       = var.azs
}
