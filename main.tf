/**
 * # AWS EKS Cluster Autoscaler Addon Terraform module
 *
 * A Terraform module to deploy the [cluster autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) addon on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-cluster-autoscaler-addon/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-cluster-autoscaler-addon/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-cluster-autoscaler/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-cluster-autoscaler/actions/workflows/pre-commit.yaml)
 */

data "aws_region" "current" {}

locals {
  addon = {
    name = "cluster-autoscaler"

    helm_chart_name    = "cluster-autoscaler"
    helm_chart_version = "9.19.1"
    helm_repo_url      = "https://kubernetes.github.io/autoscaler"
  }

  addon_irsa = {
    (local.addon.name) = {
      irsa_policy_enabled         = local.irsa_policy_enabled
      irsa_policy                 = var.irsa_policy != null ? var.irsa_policy : try(data.aws_iam_policy_document.this[0].json, "")
      pod_identity_policy_enabled = local.pod_identity_policy_enabled
      pod_identity_policy         = var.pod_identity_policy != null ? var.pod_identity_policy : try(data.aws_iam_policy_document.this[0].json, "")
    }
  }

  addon_values = yamlencode({
    rbac = {
      create = var.rbac_create != null ? var.rbac_create : true
      serviceAccount = {
        create = var.service_account_create != null ? var.service_account_create : true
        name   = var.service_account_name != null ? var.service_account_name : local.addon.name
        annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
        } : tomap({})
      }
    }
    awsRegion = data.aws_region.current.name
    autoDiscovery = {
      clusterName = var.cluster_name
    }
  })

  addon_depends_on = []
}
