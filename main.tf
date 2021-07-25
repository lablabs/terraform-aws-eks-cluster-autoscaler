data "aws_region" "current" {}

resource "helm_release" "cluster_autoscaler" {
  depends_on = [
    var.mod_dependency]
  count = var.enabled ? 1 : 0
  chart = var.helm_chart_name
  namespace = var.k8s_namespace
  name = var.helm_release_name
  version = var.helm_chart_version
  repository = var.helm_repo_url

  values = [
    yamlencode({
      "awsRegion" = data.aws_region.current.name
      "autoDiscovery" = {
        "clusterName" = var.cluster_name
      }
      "rbac" = {
        "create" = true
        "serviceAccount" = {
          "create" = true
          "name" = var.k8s_service_account_name
        }
        "serviceAccountAnnotations" = {
          "kasdvjafsjkd" = "kjasdjkdhsaf"
        }
      }
    }),
    var.values]

  dynamic "set" {
    for_each = var.settings
    content {
      name = set.key
      value = set.value
    }
  }
}
