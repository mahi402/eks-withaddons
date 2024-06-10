locals {
  name = "metrics-server"

  default_helm_config = {
    name       = local.name
    chart      = local.name
    repository = "${path.module}"
    # repository  = "https://kubernetes-sigs.github.io/metrics-server/"
    version     = "3.8.2"
    namespace   = "kube-system"
    description = "Metric server helm Chart deployment configuration"
    values      = []
    timeout     = "3600"
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )


}