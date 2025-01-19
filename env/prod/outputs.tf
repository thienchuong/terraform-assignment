output "secret_manager_name_ssh_key" {
  value = module.skeleton.secret_manager_name_ssh_key
}

output "secret_manager_arn_ssh_key" {
  value = module.skeleton.secret_manager_arn_ssh_key
}

output "vpc_info" {
  value = module.skeleton.vpc_info
}

output "bastion_info" {
  value = module.skeleton.bastion_info
}

output "webapp_info" {
  value = module.skeleton.webapp_info
}

output "lambda_info" {
  value = module.skeleton.lambda_info
}