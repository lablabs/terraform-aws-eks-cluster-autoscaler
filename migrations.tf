# Argo
moved {
  from = helm_release.argo_application
  to   = module.addon.helm_release.argo_application
}

# IRSA
moved {
  from = aws_iam_policy.this
  to   = module.addon-irsa["cluster-autoscaler"].aws_iam_policy.this
}

moved {
  from = aws_iam_role.this
  to   = module.addon-irsa["cluster-autoscaler"].aws_iam_role.this
}

moved {
  from = aws_iam_role_policy_attachment.this
  to   = module.addon-irsa["cluster-autoscaler"].aws_iam_role_policy_attachment.this
}
