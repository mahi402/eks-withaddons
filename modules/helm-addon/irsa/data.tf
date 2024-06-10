data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_id
}



data "aws_eks_cluster_auth" "example" {
  name = data.aws_eks_cluster.eks_cluster.name

}