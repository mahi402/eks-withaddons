#-------------------------------------
# Helm Add-on
#-------------------------------------

module "helm_addon" {
  depends_on = [
    data.aws_eks_cluster.eks_cluster
  ]
  source        = "../helm-addon"
  helm_config   = local.helm_config
  irsa_config   = local.irsa_config
  set_values    = local.set_values
  addon_context = var.addon_context

}

#------------------------------------
# IAM Policy
#------------------------------------

resource "aws_iam_policy" "external_dns" {
  description = "External DNS IAM policy."
  name        = "${var.addon_context.eks_cluster_id}-${local.helm_config["name"]}-irsa"
  path        = var.addon_context.irsa_iam_role_path
  policy      = data.aws_iam_policy_document.external_dns_iam_policy_document.json
  tags        = var.addon_context.tags
}
