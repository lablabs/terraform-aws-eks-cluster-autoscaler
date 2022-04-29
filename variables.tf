variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster"
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
}

variable "helm_chart_name" {
  type        = string
  default     = "cluster-autoscaler"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "9.10.3"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "cluster-autoscaler"
  description = "Helm release name"
}
variable "helm_repo_url" {
  type        = string
  default     = "https://kubernetes.github.io/autoscaler"
  description = "Helm repository"
}

variable "helm_create_namespace" {
  type        = bool
  default     = true
  description = "Create the namespace if it does not yet exist"
}

variable "namespace" {
  type        = string
  default     = "cluster-autoscaler"
  description = "The K8s namespace in which the node-problem-detector service account has been created"
}

variable "rbac_create" {
  type        = bool
  default     = true
  description = "Whether to create and use RBAC resources"
}

variable "service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create Service Account"
}

variable "irsa_role_create" {
  type        = bool
  default     = true
  description = "Whether to create IRSA role and annotate service account"
}

variable "service_account_name" {
  default     = "cluster-autoscaler"
  description = "The k8s cluster-autoscaler service account name"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://hub.helm.sh/charts/stable/cluster-autoscaler"
}

variable "values" {
  type        = string
  default     = ""
  description = "Additional yaml encoded values which will be passed to the Helm chart, see https://hub.helm.sh/charts/stable/cluster-autoscaler"
}

variable "argo_namespace" {
  type        = string
  default     = "argo"
  description = "Namespace to deploy ArgoCD application CRD to"
}

variable "argo_application_enabled" {
  type        = bool
  default     = false
  description = "If set to true, the module will be deployed as ArgoCD application, otherwise it will be deployed as a Helm release"
}

variable "argo_application_use_helm" {
  type        = bool
  default     = false
  description = "If set to true, the ArgoCD Application manifest will be deployed using Kubernetes provider as a Helm release. Otherwise it'll be deployed as a Kubernetes manifest. See Readme for more info"
}

variable "argo_application_values" {
  default     = ""
  description = "Value overrides to use when deploying argo application object with helm"
}

variable "argo_destionation_server" {
  type        = string
  default     = "https://kubernetes.default.svc"
  description = "Destination server for ArgoCD Application"
}

variable "argo_project" {
  type        = string
  default     = "default"
  description = "ArgoCD Application project"
}

variable "argo_info" {
  default = [{
    "name"  = "terraform"
    "value" = "true"
  }]
  description = "ArgoCD info manifest parameter"
}

variable "argo_sync_policy" {
  description = "ArgoCD syncPolicy manifest parameter"
  default     = {}
}
