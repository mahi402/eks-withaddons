data "aws_region" "current" {}


data "aws_iam_policy_document" "external_secrets" {
  statement {
    actions   = ["ssm:GetParameter"]
    resources = var.external_secrets_ssm_parameter_arns
  }

  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]
    resources = var.external_secrets_secrets_manager_arns
  }
}






data "aws_eks_cluster" "eks_cluster" {
  name = var.addon_context.eks_cluster_id
}

data "aws_partition" "current" {}

data "aws_eks_cluster_auth" "example" {
  name = var.addon_context.eks_cluster_id
  depends_on = [
    data.aws_eks_cluster.eks_cluster
  ]
}

