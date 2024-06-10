
resource "helm_release" "fargate-efs-helm" {
  depends_on = [
    data.aws_eks_cluster.eks_cluster, data.aws_eks_cluster_auth.example
  ]
  name         = "fargate-efs"
  repository   = path.module
  chart        = "fargate-efs"
  version      = "6.0.1"
  force_update = true

  values = [templatefile("${path.module}/values.yaml", {
    storagesize = var.storagesize
    volumeid    = var.efsvolumeid
  })]


}