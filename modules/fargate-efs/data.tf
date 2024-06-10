// Caller Identity
data "aws_ssm_parameter" "vpc_id" {
  name = var.parameter_vpc_id_name
}

data "aws_ssm_parameter" "subnet_id1" {
  name = var.parameter_subnet_id1_name
}

data "aws_ssm_parameter" "subnet_id2" {
  name = var.parameter_subnet_id2_name
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster_auth" "example" {
  name = var.eks_cluster_id
}
