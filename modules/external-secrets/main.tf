module "helm_addon" {
  source        = "../helm-addon"
  depends_on    = [kubernetes_namespace_v1.this]
  set_values    = local.set_values
  helm_config   = local.helm_config
  irsa_config   = local.irsa_config
  addon_context = var.addon_context
}

resource "aws_iam_policy" "external_secrets" {
  name        = "${var.addon_context.eks_cluster_id}-${local.helm_config["name"]}-irsa"
  path        = var.addon_context.irsa_iam_role_path
  description = "Provides permissions to for External Secrets to retrieve secrets from AWS SSM and AWS Secrets Manager"
  policy      = data.aws_iam_policy_document.external_secrets.json
  tags        = var.tags
}



resource "kubernetes_namespace_v1" "this" {

  metadata {
    name = local.helm_config["namespace"]
  }
} 