locals {
  irsa_policy_enabled         = var.irsa_policy_enabled != null ? var.irsa_policy_enabled : coalesce(var.irsa_assume_role_enabled, false) == false
  pod_identity_policy_enabled = var.pod_identity_policy_enabled != null ? var.pod_identity_policy_enabled : true
}

data "aws_iam_policy_document" "this" {
  count = var.enabled && ((local.irsa_policy_enabled && var.irsa_policy == null) || (local.pod_identity_policy_enabled && var.pod_identity_policy == null)) ? 1 : 0

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
