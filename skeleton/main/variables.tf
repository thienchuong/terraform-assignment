variable "env" {
  description = "The environment for the deployment (e.g., dev, staging, prod)."
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  description = "A list of CIDR blocks for the public subnets."
}

variable "private_subnets" {
  description = "A list of CIDR blocks for the private subnets."
}

variable "single_nat_gateway" {
  description = "Specifies whether to create a single NAT Gateway for the VPC."
}

variable "one_nat_gateway_per_az" {
  description = "Specifies whether to create one NAT Gateway per availability zone."
  default     = false
}

variable "instance_type" {
  description = "The type of instance to launch (e.g., t3.micro, m5.large)."
}

variable "min_size" {
  description = "The minimum number of instances in the Auto Scaling Group."
}

variable "max_size" {
  description = "The maximum number of instances in the Auto Scaling Group."
}

variable "desired_capacity" {
  description = "The desired number of instances in the Auto Scaling Group."
}

variable "bastion_allowed_cidr_blocks" {
  description = "A list of CIDR blocks allowed to access the bastion host."
}

variable "limited_s3_bucket" {
  description = "The name of the S3 bucket with limited access permissions."
}

variable "webapp_block_device_mapping" {
  description = "The block device mapping configuration for the web application instances."
}

variable "tags" {
  description = "A map of tags to assign to resources."
  default     = {}
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN to notify"
  type        = string
}

variable "schedule_expression" {
  description = "EventBridge schedule for ALB healtcheck by lambda"
  type        = string
}
