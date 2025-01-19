locals {
  role_name   = var.create_role ? coalesce(var.role_name, var.function_name, "*") : null
  policy_name = coalesce(var.policy_name, local.role_name, "*")

  # IAM Role trusted entities is a list of any (allow strings (services) and maps (type+identifiers))
  trusted_entities_services = distinct(compact(concat(
    slice(["lambda.amazonaws.com", "edgelambda.amazonaws.com"], 0, var.lambda_at_edge ? 2 : 1),
    [for service in var.trusted_entities : try(tostring(service), "")]
  )))

  trusted_entities_principals = [
    for principal in var.trusted_entities : {
      type        = principal.type
      identifiers = tolist(principal.identifiers)
    }
    if !can(tostring(principal))
  ]
}

################################################################################
# IAM role
################################################################################

data "aws_iam_policy_document" "assume_role" {
  count = var.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = local.trusted_entities_services
    }

    dynamic "principals" {
      for_each = local.trusted_entities_principals
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }

  dynamic "statement" {
    for_each = var.assume_role_policy_statements

    content {
      sid         = try(statement.value.sid, replace(statement.key, "/[^0-9A-Za-z]*/", ""))
      effect      = try(statement.value.effect, null)
      actions     = try(statement.value.actions, null)
      not_actions = try(statement.value.not_actions, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])
        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.condition, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_role" "lambda" {
  count = var.create_role ? 1 : 0

  name                  = local.role_name
  description           = var.role_description
  path                  = var.role_path
  force_detach_policies = var.role_force_detach_policies
  permissions_boundary  = var.role_permissions_boundary
  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  max_session_duration  = var.role_maximum_session_duration

  tags = merge(var.tags, var.role_tags)
}

################################################################################
# Cloudwatch Logs
################################################################################

data "aws_iam_policy_document" "logs" {
  count = var.create_role && var.attach_cloudwatch_logs_policy ? 1 : 0

  statement {
    effect = "Allow"

    actions = compact([
      !var.use_existing_cloudwatch_log_group && var.attach_create_log_group_permission ? "logs:CreateLogGroup" : "",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ])

    resources = flatten([for _, v in ["%v:*", "%v:*:*"] : format(v, aws_cloudwatch_log_group.lambda.arn)])
  }
}

resource "aws_iam_role_policy" "logs" {
  count = var.create_role && var.attach_cloudwatch_logs_policy ? 1 : 0

  name   = "${local.policy_name}-logs"
  role   = aws_iam_role.lambda[0].name
  policy = data.aws_iam_policy_document.logs[0].json
}

################################################################################
# Dead Letter Config
################################################################################

data "aws_iam_policy_document" "dead_letter" {
  count = var.create_role && var.attach_dead_letter_policy ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "sns:Publish",
      "sqs:SendMessage",
    ]

    resources = [
      var.dead_letter_target_arn,
    ]
  }
}

resource "aws_iam_role_policy" "dead_letter" {
  count = var.create_role && var.attach_dead_letter_policy ? 1 : 0

  name   = "${local.policy_name}-dl"
  role   = aws_iam_role.lambda[0].name
  policy = data.aws_iam_policy_document.dead_letter[0].json
}

################################################################################
# VPC
################################################################################

data "aws_iam_policy" "vpc" {
  count = var.create_role && var.attach_network_policy ? 1 : 0

  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
}

resource "aws_iam_role_policy" "vpc" {
  count = var.create_role && var.attach_network_policy ? 1 : 0

  name   = "${local.policy_name}-vpc"
  role   = aws_iam_role.lambda[0].name
  policy = data.aws_iam_policy.vpc[0].policy
}

################################################################################
# Failure/Success Async Events
################################################################################

data "aws_iam_policy_document" "async" {
  count = var.create_role && var.attach_async_event_policy ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "sns:Publish",
      "sqs:SendMessage",
      "events:PutEvents",
      "lambda:InvokeFunction",
    ]

    resources = compact(distinct([var.destination_on_failure, var.destination_on_success]))
  }
}

resource "aws_iam_role_policy" "async" {
  count = var.create_role && var.attach_async_event_policy ? 1 : 0

  name   = "${local.policy_name}-async"
  role   = aws_iam_role.lambda[0].name
  policy = data.aws_iam_policy_document.async[0].json
}

################################################################################
# Additional policy (JSON)
################################################################################

resource "aws_iam_role_policy" "additional_json" {
  count = var.create_role && var.attach_policy_json ? 1 : 0

  name   = "${local.policy_name}-${var.policy_name_suffix_additional_json}"
  role   = aws_iam_role.lambda[0].name
  policy = var.policy_json
}

################################################################################
# Additional policies (list of JSON)
################################################################################

resource "aws_iam_role_policy" "additional_jsons" {
  count = var.create_role && var.attach_policy_jsons ? var.number_of_policy_jsons : 0

  name   = "${local.policy_name}-${count.index}"
  role   = aws_iam_role.lambda[0].name
  policy = var.policy_jsons[count.index]
}
