# Argo
moved {
  from = helm_release.argo_application[0]
  to   = module.addon.helm_release.argo_application[0]
}

# IRSA
moved {
  from = aws_iam_policy.this[0]
  to   = module.addon-irsa["cluster-autoscaler"].aws_iam_policy.irsa[0]
}

moved {
  from = aws_iam_role.this[0]
  to   = module.addon-irsa["cluster-autoscaler"].aws_iam_role.irsa[0]
}

moved {
  from = aws_iam_role_policy_attachment.this[0]
  to   = module.addon-irsa["cluster-autoscaler"].aws_iam_role_policy_attachment.irsa[0]
}
