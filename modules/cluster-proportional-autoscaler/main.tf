#-------------------------------------------------
# Cluster Proportional Autoscaler Helm Add-on
#-------------------------------------------------
module "helm_addon" {
  source = "../helm-addon"

  helm_config   = local.helm_config
  set_values    = local.set_values
  irsa_config   = null
  addon_context = var.addon_context
}
