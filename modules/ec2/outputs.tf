output "instance_id" {
  description = "The ID of the created instance."
  value       = aws_instance.this.*.id
}

output "instance_private_ip" {
  description = "The private IP address of the instance."
  value       = aws_instance.this.*.private_ip
}

output "instance_public_ip" {
  description = "The public IP address of the instance (if applicable)."
  value       = aws_instance.this.*.public_ip
}

output "launch_template_id" {
  description = "The ID of the created launch template."
  value       = aws_launch_template.this.*.id
}

output "autoscaling_group_id" {
  description = "The id of the created Auto Scaling Group."
  value       = aws_autoscaling_group.this.*.id
}

output "autoscaling_group_name" {
  description = "The name of the created Auto Scaling Group."
  value       = aws_autoscaling_group.this.*.name
}
