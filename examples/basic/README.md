# Basic example

The code in this example shows how to use the module with basic configuration and minimal set of other resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.35.0, < 5.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.16.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_addon_installation_argo_helm"></a> [addon\_installation\_argo\_helm](#module\_addon\_installation\_argo\_helm) | ../../ | n/a |
| <a name="module_addon_installation_argo_kubernetes"></a> [addon\_installation\_argo\_kubernetes](#module\_addon\_installation\_argo\_kubernetes) | ../../ | n/a |
| <a name="module_addon_installation_disabled"></a> [addon\_installation\_disabled](#module\_addon\_installation\_disabled) | ../../ | n/a |
| <a name="module_addon_installation_helm"></a> [addon\_installation\_helm](#module\_addon\_installation\_helm) | ../../ | n/a |
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | cloudposse/eks-cluster/aws | 2.3.0 |
| <a name="module_eks_node_group"></a> [eks\_node\_group](#module\_eks\_node\_group) | cloudposse/eks-node-group/aws | 2.4.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
