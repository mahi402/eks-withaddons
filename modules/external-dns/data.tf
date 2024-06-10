# TODO - remove at next breaking change
# data "aws_route53_zone" "selected" {
#   name         = "${upper(var.domain_env) == "NONPROD" ? "nonprod.pge.com" : "prod.pge.com"}"
#   private_zone = var.private_zone
# }

data "aws_iam_policy_document" "external_dns_iam_policy_document" {
  statement {
    effect = "Allow"
    resources = distinct(concat(
      ["arn:aws:route53:::hostedzone/${upper(var.domain_env) == "NONPROD" ? "Z08389243G1Q2O35V7GIP" : "Z11LPAP1YPL6IP"}"],
      var.route53_zone_arns
    ))
    actions = ["route53:ChangeResourceRecordSets"]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]
  }

  statement {
    sid       = "PermissionToAssumeTFCBR53Role"
    effect    = "Allow"
    resources = ["arn:aws:iam::${upper(var.domain_env) == "NONPROD" ? "514712703977" : "686137062481"}:role/TFCBR53Role"]
    actions = [
      "sts:AssumeRole",
    ]
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
