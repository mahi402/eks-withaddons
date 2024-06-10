module "helm_addon" {
  source        = "../helm-addon"
  set_values    = local.set_values
  helm_config   = local.helm_config
  irsa_config   = local.irsa_config
  addon_context = var.addon_context
}
