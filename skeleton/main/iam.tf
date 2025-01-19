################################################################################
# EC2 instance profile
################################################################################

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "limited_s3_access" {
  statement {
    sid    = "AllowListBucketContents"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      for k in var.limited_s3_bucket : "arn:aws:s3:::${k}"
    ]
  }

  statement {
    sid    = "AllowSpecificObjectActions"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject"
    ]
    resources = [
      for k in var.limited_s3_bucket : "arn:aws:s3:::${k}/*"
    ]
  }
}

resource "aws_iam_policy" "limited_s3_access" {
  name        = "${local.name}-iam-policy-limited-s3"
  description = "Policy granting limited access to some S3 buckets"
  policy      = data.aws_iam_policy_document.limited_s3_access.json
}

resource "aws_iam_role" "instance_profile" {
  name               = "${local.name}-common-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.instance_profile.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "limited_s3_access" {
  role       = aws_iam_role.instance_profile.name
  policy_arn = aws_iam_policy.limited_s3_access.arn
}

resource "aws_iam_instance_profile" "common" {
  name = "${local.name}-common-instance-profile"
  role = aws_iam_role.instance_profile.name
}

data "aws_iam_policy_document" "lambda_sns" {
  statement {
    sid    = "AllowPublishSNS"
    effect = "Allow"

    actions = [
      "sns:Publish"
    ]

    resources = ["*"]
  }
}
