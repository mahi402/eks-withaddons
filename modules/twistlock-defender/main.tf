


resource "kubernetes_namespace_v1" "irsa" {
  count = var.create_kubernetes_namespace ? 1 : 0

  metadata {
    name = "twistlock"
  }
}



resource "helm_release" "twistlock-defender" {
  name       = "twistlock-defender"
  repository = path.module
  chart      = "twistlock-defender"
  namespace  = "twistlock"
  values = [templatefile("${path.module}/values.yaml", {
    cluster_id = var.eks_cluster_id
  })]


}