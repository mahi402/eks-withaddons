locals {
  name                 = "cni-metrics-helper"
  service_account_name = "${local.name}-sa"

  default_helm_config = {
    name        = local.name
    chart       = local.name
    repository  = "${path.module}"
    namespace   = "kube-system"
    version     = "0.1.10"
    description = "cni-metrics-helper helm Chart deployment configuration"
    values      = []
    timeout     = "1200"
  }
  set_values = concat(
    [
      {
        name  = "serviceAccount.name"
        value = local.service_account_name
      },
      {
        name  = "serviceAccount.create"
        value = false
      }
    ],
    try(var.helm_config.set_values, [])
  )

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )


  irsa_config = {
    kubernetes_namespace              = local.helm_config["namespace"]
    kubernetes_service_account        = local.service_account_name
    create_kubernetes_namespace       = try(local.helm_config["create_namespace"], true)
    create_kubernetes_service_account = true
    irsa_iam_policies                 = [aws_iam_policy.cni_metrics.arn]
  }
}