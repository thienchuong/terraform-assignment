variable "name" {
  description = "The name prefix to assign to all resources."
  type        = string
}

variable "cidr_block" {
  description = "The primary CIDR block for the VPC."
  type        = string
}

variable "instance_tenancy" {
  description = "The tenancy option for instances launched into the VPC. Valid values are 'default', 'dedicated', or 'host'."
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "Enable or disable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable or disable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "enable_network_address_usage_metrics" {
  description = "Enable network address usage metrics for the VPC."
  type        = bool
  default     = false
}

variable "ipv4_ipam_pool_id" {
  description = "The ID of the IPv4 IPAM pool to allocate the VPC CIDR block from."
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "The netmask length to allocate from the IPv4 IPAM pool."
  type        = number
  default     = null
}

variable "ipv6_cidr_block" {
  description = "The IPv6 CIDR block for the VPC."
  type        = string
  default     = null
}

variable "ipv6_ipam_pool_id" {
  description = "The ID of the IPv6 IPAM pool to allocate the VPC CIDR block from."
  type        = string
  default     = null
}

variable "ipv6_netmask_length" {
  description = "The netmask length to allocate from the IPv6 IPAM pool."
  type        = number
  default     = null
}

variable "ipv6_cidr_block_network_border_group" {
  description = "The network border group for the IPv6 CIDR block."
  type        = string
  default     = null
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Assign an Amazon-provided IPv6 CIDR block to the VPC."
  type        = bool
  default     = false
}

variable "secondary_cidr_blocks" {
  description = "A list of secondary CIDR blocks to associate with the VPC."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags specifically for the VPC."
  type        = map(string)
  default     = {}
}

variable "enable_dhcp_options" {
  description = "Enable or disable DHCP options for the VPC."
  type        = bool
  default     = false
}

variable "dhcp_options_domain_name" {
  description = "The domain name for the DHCP options set."
  type        = string
  default     = null
}

variable "dhcp_options_domain_name_servers" {
  description = "A list of domain name servers for the DHCP options set."
  type        = list(string)
  default     = []
}

variable "dhcp_options_ntp_servers" {
  description = "A list of NTP servers for the DHCP options set."
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "A list of NetBIOS name servers for the DHCP options set."
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "The NetBIOS node type for the DHCP options set."
  type        = number
  default     = null
}

variable "dhcp_options_ipv6_address_preferred_lease_time" {
  description = "Preferred lease time for IPv6 addresses in the DHCP options set."
  type        = string
  default     = null
}

variable "dhcp_options_tags" {
  description = "Tags to assign to the DHCP options set."
  type        = map(string)
  default     = {}
}

variable "create_igw" {
  description = "Enable or disable the creation of an Internet Gateway."
  type        = bool
  default     = true
}

variable "igw_tags" {
  description = "Tags to assign to the Internet Gateway."
  type        = map(string)
  default     = {}
}

variable "create_nat_gateway" {
  description = "Enable or disable the creation of NAT Gateways."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for the VPC."
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Create one NAT Gateway per availability zone."
  type        = bool
  default     = false
}

variable "nat_eip_tags" {
  description = "Tags to assign to the Elastic IPs used by NAT Gateways."
  type        = map(string)
  default     = {}
}

variable "nat_gateway_tags" {
  description = "Tags to assign to NAT Gateways."
  type        = map(string)
  default     = {}
}

variable "create_private_nat_gateway_route" {
  description = "Create private routes for NAT Gateways."
  type        = bool
  default     = false
}

variable "azs" {
  description = "A list of availability zones for subnet placement."
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of CIDR blocks for public subnets."
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of CIDR blocks for private subnets."
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Assign a public IP to instances launched in public subnets."
  type        = bool
  default     = true
}

variable "public_subnet_ipv6_native" {
  description = "Create IPv6-only public subnets."
  type        = bool
  default     = false
}

variable "public_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 addresses to instances launched in public subnets."
  type        = bool
  default     = false
}

variable "public_subnet_enable_dns64" {
  description = "Enable DNS64 for public subnets."
  type        = bool
  default     = false
}

variable "public_subnet_enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Enable DNS AAAA record responses for public subnets."
  type        = bool
  default     = false
}

variable "public_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Enable DNS A record responses for public subnets."
  type        = bool
  default     = false
}

variable "private_subnet_ipv6_native" {
  description = "Create IPv6-only private subnets."
  type        = bool
  default     = false
}

variable "private_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 addresses to instances launched in private subnets."
  type        = bool
  default     = false
}

variable "private_subnet_enable_dns64" {
  description = "Enable DNS64 for private subnets."
  type        = bool
  default     = false
}

variable "private_subnet_enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Enable DNS AAAA record responses for private subnets."
  type        = bool
  default     = false
}

variable "private_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Enable DNS A record responses for private subnets."
  type        = bool
  default     = false
}

variable "public_subnet_tags" {
  description = "Tags to assign to public subnets."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Tags to assign to private subnets."
  type        = map(string)
  default     = {}
}

variable "create_multiple_public_route_tables" {
  description = "Indicates whether to create a separate route table for each public subnet. Default: `false`"
  type        = bool
  default     = false
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public-subnet"
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route tables"
  type        = map(string)
  default     = {}
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private-subnet"
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables"
  type        = map(string)
  default     = {}
}

variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block"
  type        = bool
  default     = false
}

variable "public_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "public_subnet_private_dns_hostname_type_on_launch" {
  description = "The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID. Valid values: `ip-name`, `resource-name`"
  type        = string
  default     = null
}

variable "public_subnet_names" {
  description = "Explicit values to use in the Name tag on public subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "public_subnet_tags_per_az" {
  description = "Additional tags for the public subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "private_subnet_private_dns_hostname_type_on_launch" {
  description = "The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID. Valid values: `ip-name`, `resource-name`"
  type        = string
  default     = null
}

variable "private_subnet_tags_per_az" {
  description = "Additional tags for the private subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "private_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}
