locals {
  optional_tags = {
    "name" = var.eks_cluster_id
  }
  sg_name = join("-", [var.eks_cluster_id, "efs-sg"])


}


