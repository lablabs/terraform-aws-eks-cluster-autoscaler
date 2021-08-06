locals {
  values = yamlencode({
      "awsRegion" : data.aws_region.current.name,
      "autoDiscovery" : {
        "clusterName" : var.cluster_name
      },
      "rbac" : {
        "create" : true,
        "serviceAccount" : {
          "create" : true,
          "name" : var.k8s_service_account_name
          "annotations" : {
            "eks.amazonaws.com/role-arn" : var.enabled ? aws_iam_role.cluster_autoscaler[0].arn : ""
          }
        }
      }
    })
}

data "aws_region" "current" {}

data "utils_deep_merge_yaml" "values" {
  count      = var.enabled ? 1 : 0
  input      = compact([
    local.values,
    var.values
  ])
}

resource "helm_release" "cluster_autoscaler" {
  count            = var.enabled ? 1 : 0
  chart            = var.helm_chart_name
  create_namespace = var.helm_create_namespace
  namespace        = var.k8s_namespace
  name             = var.helm_release_name
  version          = var.helm_chart_version
  repository       = var.helm_repo_url

  values = [
    data.utils_deep_merge_yaml.values[0].output
  ]

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
