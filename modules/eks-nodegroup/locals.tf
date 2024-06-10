locals {
  default_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]
  eks_arns            = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonSSMFullAccess","arn:aws:iam::aws:policy/AmazonRDSFullAccess","arn:aws:iam::aws:policy/SecretsManagerReadWrite","arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"]
  namespace           = "ccoe-tf-developers"
}

### Default tags for eks cluster and managed node groups###

locals {
  tags = {
    "k8s.io/cluster-autoscaler/enabled"             = true
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = true
    "kubernetes.io/cluster/${var.cluster_name}"     = "owned"
  }
}


