variable "name" {
  description = "The name prefix for all resources."
  type        = string
}

variable "ami" {
  description = "The AMI ID to use for launching the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
  default     = "t3.micro"
}

variable "cpu_core_count" {
  description = "The number of CPU cores for the instance."
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "The number of threads per CPU core."
  type        = number
  default     = null
}

variable "hibernation" {
  description = "Enable hibernation for the instance."
  type        = bool
  default     = false
}

variable "user_data" {
  description = "The user data script to initialize the instance."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Base64 encoded user data script."
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "Trigger instance replacement when user data changes."
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "The availability zone for the instance."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in."
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the instance."
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the instance."
  type        = string
  default     = null
}

variable "monitoring" {
  description = "Enable detailed monitoring for the instance."
  type        = bool
  default     = false
}

variable "get_password_data" {
  description = "Retrieve the instance password data for Windows instances."
  type        = bool
  default     = false
}

variable "iam_instance_profile_arn" {
  description = "The ARN of the IAM instance profile to associate with the instance."
  type        = string
  default     = null
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile to associate with the instance."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Assign a public IP address to the instance."
  type        = bool
  default     = true
}

variable "private_ip" {
  description = "The private IP address to assign to the instance."
  type        = string
  default     = null
}

variable "secondary_private_ips" {
  description = "List of secondary private IP addresses to assign to the instance."
  type        = list(string)
  default     = []
}

variable "ipv6_address_count" {
  description = "The number of IPv6 addresses to assign to the instance."
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "List of IPv6 addresses to assign to the instance."
  type        = list(string)
  default     = []
}

variable "ebs_optimized" {
  description = "Enable EBS optimization for the instance."
  type        = bool
  default     = false
}

variable "root_block_device" {
  description = "Configuration for the root block device of the instance."
  type = list(object({
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id            = optional(string)
    volume_size           = optional(number)
    volume_type           = optional(string)
    throughput            = optional(number)
    tags                  = optional(map(string))
  }))
  default = []
}

variable "ebs_block_device" {
  description = "Configuration for additional EBS block devices."
  type = list(object({
    delete_on_termination = optional(bool)
    device_name           = string
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id            = optional(string)
    snapshot_id           = optional(string)
    volume_size           = optional(number)
    volume_type           = optional(string)
    throughput            = optional(number)
    tags                  = optional(map(string))
  }))
  default = []
}

variable "ephemeral_block_device" {
  description = "Configuration for ephemeral block devices."
  type = list(object({
    device_name  = string
    no_device    = optional(bool)
    virtual_name = optional(string)
  }))
  default = []
}

variable "network_interface" {
  description = "Configuration for network interfaces."
  type = list(object({
    device_index          = number
    network_interface_id  = optional(string)
    delete_on_termination = optional(bool)
  }))
  default = []
}

variable "source_dest_check" {
  description = "Enable or disable source/destination checks for the instance."
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "Disable the ability to terminate the instance via the API."
  type        = bool
  default     = false
}

variable "disable_api_stop" {
  description = "Disable the ability to stop the instance via the API."
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "The shutdown behavior for the instance. Options are 'stop' or 'terminate'."
  type        = string
  default     = "stop"
}

variable "placement_group" {
  description = "The placement group for the instance."
  type        = string
  default     = null
}

variable "tenancy" {
  description = "The tenancy of the instance. Options are 'default', 'dedicated', or 'host'."
  type        = string
  default     = "default"
}

variable "host_id" {
  description = "The host ID for a dedicated host."
  type        = string
  default     = null
}

variable "cpu_credits" {
  description = "The credit option for burstable performance instances. Options are 'standard' or 'unlimited'."
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "A map of tags to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "instance_tags" {
  description = "Additional tags specifically for the instance."
  type        = map(string)
  default     = {}
}

variable "enable_volume_tags" {
  description = "Enable tagging of EBS volumes."
  type        = bool
  default     = false
}

variable "volume_tags" {
  description = "Tags to assign to EBS volumes."
  type        = map(string)
  default     = {}
}

variable "create_launch_template_asg" {
  description = "Enable the creation of a launch template for the Auto Scaling Group."
  type        = bool
  default     = false
}

variable "launch_template_name" {
  description = "The name of the launch template."
  type        = string
  default     = null
}

variable "launch_template_version" {
  description = "The version of the launch template to use."
  type        = string
  default     = null
}

variable "launch_template_use_name_prefix" {
  description = "Determines whether to use `launch_template_name` as is or create a unique name beginning with the `launch_template_name` as the prefix"
  type        = bool
  default     = true
}

variable "launch_template_description" {
  description = "Description of the launch template"
  type        = string
  default     = "Description of the launch template"
}

variable "network_interfaces" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(any)
  default     = []
}

variable "default_version" {
  description = "Default Version of the launch template"
  type        = string
  default     = null
}

variable "update_default_version" {
  description = "Whether to update Default Version each update. Conflicts with `default_version`"
  type        = bool
  default     = null
}

variable "kernel_id" {
  description = "The kernel ID"
  type        = string
  default     = null
}

variable "ram_disk_id" {
  description = "The ID of the ram disk"
  type        = string
  default     = null
}

variable "launch_template_block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"
  type        = list(any)
  default     = []
}

variable "credit_specification" {
  description = "Customize the credit specification of the instance"
  type        = map(string)
  default     = {}
}

variable "tag_specifications" {
  description = "The tags to apply to the resources during launch"
  type        = list(any)
  default     = []
}

variable "launch_template_id" {
  description = "ID of an existing launch template to be used (created outside of this module)"
  type        = string
  default     = null
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with the `name` as the prefix"
  type        = bool
  default     = true
}

variable "availability_zones" {
  description = "A list of one or more availability zones for the group. Used for EC2-Classic and default subnets when not specified with `vpc_zone_identifier` argument. Conflicts with `vpc_zone_identifier`"
  type        = list(string)
  default     = null
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with `availability_zones`"
  type        = list(string)
  default     = null
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  default     = null
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  default     = null
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
  default     = null
}

variable "capacity_rebalance" {
  description = "Indicates whether capacity rebalance is enabled"
  type        = bool
  default     = null
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
  type        = number
  default     = null
}

variable "wait_for_elb_capacity" {
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over `min_elb_capacity` behavior."
  type        = number
  default     = null
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  type        = string
  default     = null
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = null
}

variable "desired_capacity_type" {
  description = "The unit of measurement for the value specified for desired_capacity. Supported for attribute-based instance type selection only. Valid values: `units`, `vcpu`, `memory-mib`."
  type        = string
  default     = null
}

variable "default_instance_warmup" {
  description = "Amount of time, in seconds, until a newly launched instance can contribute to the Amazon CloudWatch metrics. This delay lets an instance finish initializing before Amazon EC2 Auto Scaling aggregates instance metrics, resulting in more reliable usage data. Set this value equal to the amount of time that it takes for resource consumption to become stable after an instance reaches the InService state."
  type        = number
  default     = null
}

variable "protect_from_scale_in" {
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events."
  type        = bool
  default     = false
}

variable "health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  type        = string
  default     = null
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = null
}

variable "force_delete" {
  description = "Allows deleting the Auto Scaling Group without waiting for all instances in the pool to terminate. You can force an Auto Scaling Group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
  type        = bool
  default     = false
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the Auto Scaling Group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `OldestLaunchTemplate`, `AllocationStrategy`, `Default`"
  type        = list(string)
  default     = []
}

variable "suspended_processes" {
  description = "A list of processes to suspend for the Auto Scaling Group. The allowed values are `Launch`, `Terminate`, `HealthCheck`, `ReplaceUnhealthy`, `AZRebalance`, `AlarmNotification`, `ScheduledActions`, `AddToLoadBalancer`, `InstanceRefresh`. Note that if you suspend either the `Launch` or `Terminate` process types, it can prevent your Auto Scaling Group from functioning properly"
  type        = list(string)
  default     = []
}

variable "max_instance_lifetime" {
  description = "The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 86400 and 31536000 seconds"
  type        = number
  default     = null
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are `GroupDesiredCapacity`, `GroupInServiceCapacity`, `GroupPendingCapacity`, `GroupMinSize`, `GroupMaxSize`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupStandbyCapacity`, `GroupTerminatingCapacity`, `GroupTerminatingInstances`, `GroupTotalCapacity`, `GroupTotalInstances`"
  type        = list(string)
  default     = []
}

variable "metrics_granularity" {
  description = "The granularity to associate with the metrics to collect. The only valid value is `1Minute`"
  type        = string
  default     = null
}

variable "service_linked_role_arn" {
  description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
  type        = string
  default     = null
}

variable "ignore_failed_scaling_activities" {
  description = "Whether to ignore failed Auto Scaling scaling activities while waiting for capacity. The default is false -- failed scaling activities cause errors to be returned."
  type        = bool
  default     = false
}

variable "asg_tags" {
  description = "A map of additional tags to add to the autoscaling group"
  type        = map(string)
  default     = {}
}