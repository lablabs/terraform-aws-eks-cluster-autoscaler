locals {
  helm_values = yamlencode({
    "awsRegion" : data.aws_region.current.name,
    "autoDiscovery" : {
      "clusterName" : var.cluster_name
    },
    "rbac" : {
      "create" : var.rbac_create,
      "serviceAccount" : {
        "create" : var.service_account_create,
        "name" : var.service_account_name
        "annotations" : {
          "eks.amazonaws.com/role-arn" : local.irsa_role_create ? aws_iam_role.this[0].arn : ""
        }
      }
    }
  })
}

data "aws_region" "current" {}

data "utils_deep_merge_yaml" "helm_values" {
  count = var.enabled ? 1 : 0
  input = compact([
    local.helm_values,
    var.helm_values
  ])
}