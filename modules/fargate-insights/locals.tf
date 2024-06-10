locals {
  namespace      = "fargate-container-insights"
  serviceaccount = "adot-collector"
  irsa_iam_role  = join("-", [var.addon_context.eks_cluster_id, "EKS-Fargate-ADOT-sa"])
}