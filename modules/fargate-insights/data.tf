
data "aws_eks_cluster" "eks_cluster" {
  name = var.addon_context.eks_cluster_id
}

data "aws_region" "current" {}

data "aws_eks_cluster_auth" "example" {
  name = var.addon_context.eks_cluster_id
  depends_on = [
    data.aws_eks_cluster.eks_cluster
  ]
}
