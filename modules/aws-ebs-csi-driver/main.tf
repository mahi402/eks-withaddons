locals {
  name            = "aws-ebs-csi-driver"
  namespace       = try(var.helm_config.namespace, "kube-system")
  service_account = try(var.helm_config.service_account, "ebs-csi-controller-sa")
}

data "aws_eks_addon_version" "this" {
  addon_name = local.name
  # Need to allow both config routes - for managed and self-managed configs
  kubernetes_version = try(var.addon_config.kubernetes_version, var.helm_config.kubernetes_version)
  most_recent        = try(var.addon_config.most_recent, var.helm_config.most_recent, false)
}

module "helm_addon" {
  source = "../helm-addon"
  # https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/charts/aws-ebs-csi-driver/Chart.yaml
  helm_config = merge({
    name        = local.name
    description = "The Amazon Elastic Block Store Container Storage Interface (CSI) Driver provides a CSI interface used by Container Orchestrators to manage the lifecycle of Amazon EBS volumes."
    chart       = local.name
    version     = "2.12.1"
    repository  = path.module
    namespace   = local.namespace
    values = [
      <<-EOT
      image:
        repository: public.ecr.aws/ebs-csi-driver/aws-ebs-csi-driver
        tag: ${try(var.helm_config.addon_version, replace(data.aws_eks_addon_version.this.version, "/-eksbuild.*/", ""))}
      controller:
        k8sTagClusterId: ${var.addon_context.eks_cluster_id}
      EOT
    ]
    },
    var.helm_config
  )

  set_values = [
    {
      name  = "controller.serviceAccount.create"
      value = "false"
    }
  ]

  irsa_config = {
    create_kubernetes_namespace       = try(var.helm_config.create_namespace, false)
    kubernetes_namespace              = local.namespace
    create_kubernetes_service_account = true
    kubernetes_service_account        = local.service_account
    irsa_iam_policies                 = concat([aws_iam_policy.aws_ebs_csi_driver.arn], lookup(var.helm_config, "additional_iam_policies", []))
  }

  # Blueprints
  addon_context = var.addon_context
}


resource "aws_iam_policy" "aws_ebs_csi_driver" {


  name        = "${var.addon_context.eks_cluster_id}-aws-ebs-csi-driver-irsa"
  description = "IAM Policy for AWS EBS CSI Driver"
  # path        = try(var.addon_context.irsa_iam_role_path, null)
  policy = data.aws_iam_policy_document.aws_ebs_csi_driver.json

  tags = merge(
    var.addon_context.tags,
    try(var.addon_config.tags, {})
  )
}
