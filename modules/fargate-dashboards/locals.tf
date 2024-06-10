locals {
  cloudwatch-dashboard = join("-", [var.addon_context.eks_cluster_id, "Cluster-Level-Dashboard"])

}