resource "helm_release" "fargate-insights" {
  depends_on = [
    data.aws_eks_cluster_auth.example, module.irsa
  ]
  name       = "fargate-insights"
  repository = path.module
  chart      = "fargate-insights"
  version    = "6.0.1"


  values = [templatefile("${path.module}/values.yaml", {
    serviceaccount = local.serviceaccount
    namespace      = local.namespace
    clustername    = var.addon_context.eks_cluster_id
    region         = data.aws_region.current.id
  })]
}

module "irsa" {

  depends_on = [
    data.aws_eks_cluster.eks_cluster
  ]
  source                            = "../helm-addon/irsa"
  create_kubernetes_service_account = true
  kubernetes_namespace              = local.namespace
  create_kubernetes_namespace       = true
  kubernetes_service_account        = local.serviceaccount
  irsa_iam_policies                 = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
  irsa_iam_role_name                = local.irsa_iam_role
  irsa_iam_role_path                = "/"
  irsa_iam_permissions_boundary     = ""
  eks_cluster_id                    = var.addon_context.eks_cluster_id
  eks_cluster_endpoint              = var.addon_context.aws_eks_cluster_endpoint
  eks_oidc_provider_arn             = var.addon_context.eks_oidc_provider_arn
  tags                              = var.tags
}