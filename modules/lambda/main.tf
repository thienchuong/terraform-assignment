data "aws_partition" "current" {}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id
  skip_destroy      = var.cloudwatch_logs_skip_destroy
  log_group_class   = var.cloudwatch_logs_log_group_class

  tags = var.tags
}

resource "aws_lambda_function" "this" {
  function_name                      = var.function_name
  description                        = var.description
  role                               = var.create_role ? aws_iam_role.lambda[0].arn : var.lambda_role
  handler                            = var.package_type != "Zip" ? null : var.handler
  memory_size                        = var.memory_size
  reserved_concurrent_executions     = var.reserved_concurrent_executions
  runtime                            = var.package_type != "Zip" ? null : var.runtime
  layers                             = var.layers
  timeout                            = var.timeout
  publish                            = var.publish
  kms_key_arn                        = var.kms_key_arn
  image_uri                          = var.image_uri
  package_type                       = var.package_type
  architectures                      = var.architectures
  code_signing_config_arn            = var.code_signing_config_arn
  replace_security_groups_on_destroy = var.replace_security_groups_on_destroy
  replacement_security_group_ids     = var.replacement_security_group_ids
  skip_destroy                       = var.skip_destroy

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size == null ? [] : [true]

    content {
      size = var.ephemeral_storage_size
    }
  }

  filename         = var.source_path
  source_code_hash = var.source_code_hash

  s3_bucket         = try(var.s3_existing_package.bucket, null)
  s3_key            = try(var.s3_existing_package.key, null)
  s3_object_version = try(var.s3_existing_package.object_version, null)

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn == null ? [] : [true]
    content {
      target_arn = var.dead_letter_target_arn
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_mode == null ? [] : [true]
    content {
      mode = var.tracing_mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids          = var.vpc_security_group_ids
      subnet_ids                  = var.vpc_subnet_ids
      ipv6_allowed_for_dual_stack = var.ipv6_allowed_for_dual_stack
    }
  }

  dynamic "file_system_config" {
    for_each = var.file_system_arn != null && var.file_system_local_mount_path != null ? [true] : []
    content {
      local_mount_path = var.file_system_local_mount_path
      arn              = var.file_system_arn
    }
  }

  tags = merge(
    { "Name" = var.function_name },
    var.tags,
  )

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy.additional_json,
    aws_iam_role_policy.additional_jsons,
    aws_iam_role_policy.async,
    aws_iam_role_policy.dead_letter,
    aws_iam_role_policy.logs,
  ]
}

resource "aws_lambda_permission" "this" {
  for_each = { for k, v in var.allowed_triggers : k => v }

  function_name = aws_lambda_function.this.function_name

  statement_id_prefix    = try(each.value.statement_id, each.key)
  action                 = try(each.value.action, "lambda:InvokeFunction")
  principal              = try(each.value.principal, format("%s.amazonaws.com", try(each.value.service, "")))
  principal_org_id       = try(each.value.principal_org_id, null)
  source_arn             = try(each.value.source_arn, null)
  source_account         = try(each.value.source_account, null)
  event_source_token     = try(each.value.event_source_token, null)
  function_url_auth_type = try(each.value.function_url_auth_type, null)

  lifecycle {
    create_before_destroy = true
  }
}