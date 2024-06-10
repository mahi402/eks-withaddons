locals {
  name = "kube-state-metrics"

  default_helm_config = {
    name       = local.name
    chart      = local.name
    repository = "${path.module}"
    # repository  = "https://prometheus-community.github.io/helm-charts"
    version     = "4.16.0"
    namespace   = "kube-system"
    description = "Install kube-state-metrics to generate and expose cluster-level metrics"
    values      = []
    timeout     = "3600"
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )


}