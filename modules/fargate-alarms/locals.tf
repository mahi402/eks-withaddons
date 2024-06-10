locals {
  podcpu-alarm  = join("-", [var.addon_context.eks_cluster_id, "podcpu"])
  network-alarm = join("-", [var.addon_context.eks_cluster_id, "network"])
  podmem-alarm  = join("-", [var.addon_context.eks_cluster_id, "podmem"])
}