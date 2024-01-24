locals {
  irsa_role_create = var.enabled && var.rbac_create && var.service_account_create && var.irsa_role_create
}

data "aws_iam_policy_document" "this" {
  count = local.irsa_role_create && var.irsa_policy_enabled && !var.irsa_assume_role_enabled ? 1 : 0

  statement {
    sid = "Autoscaling"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeImages",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup"
    ]

    #checkov:skip=CKV_AWS_111: Ensure IAM policies does not allow write access without constraints
    #checkov:skip=CKV_AWS_356: Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions
    resources = [
      "*",
    ]

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "this_assume" {
  count = local.irsa_role_create && var.irsa_assume_role_enabled ? 1 : 0

  statement {
    sid    = "AllowAssumeClusterAutoscalerRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      var.irsa_assume_role_arn
    ]
  }
}

resource "aws_iam_policy" "this" {
  count = local.irsa_role_create && (var.irsa_policy_enabled || var.irsa_assume_role_enabled) ? 1 : 0

  name        = "${var.irsa_role_name_prefix}-${var.helm_chart_name}" # tflint-ignore: aws_iam_policy_invalid_name
  path        = "/"
  description = "Policy for cluster-autoscaler service"
  policy      = var.irsa_assume_role_enabled ? data.aws_iam_policy_document.this_assume[0].json : data.aws_iam_policy_document.this[0].json

  tags = var.irsa_tags
}

data "aws_iam_policy_document" "this_irsa" {
  count = local.irsa_role_create ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "this" {
  count                = local.irsa_role_create ? 1 : 0
  name                 = "${var.irsa_role_name_prefix}-${var.helm_chart_name}" # tflint-ignore: aws_iam_role_invalid_name
  assume_role_policy   = data.aws_iam_policy_document.this_irsa[0].json
  permissions_boundary = var.irsa_permissions_boundary
  tags                 = var.irsa_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = local.irsa_role_create && var.irsa_policy_enabled ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_role_policy_attachment" "this_additional" {
  for_each   = local.irsa_role_create ? var.irsa_additional_policies : {}
  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}
