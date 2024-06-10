module "helm_addon" {
  source = "../helm-addon"

  helm_config   = local.helm_config
  irsa_config   = local.irsa_config
  addon_context = var.addon_context
}

resource "aws_iam_policy" "cni_metrics" {
  name        = "${var.addon_context.eks_cluster_id}-cni-metrics"
  description = "IAM policy for EKS CNI Metrics helper"
  path        = "/"
  policy      = data.aws_iam_policy_document.cni_metrics.json
  tags        = var.addon_context.tags

}

data "aws_iam_policy_document" "cni_metrics" {
  statement {
    sid = "CNIMetrics"
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }
}
