/*
 * # AWS eks cluster with  managed node group creation
 * This module will create eks and  managed groups.
*/
# Filename     : eks-modules/aws/modules/eks/modules/kubernetes-addons/main.tf
#  Date        : 26 july 2022
#  Author      : TekYantra
#  Description : kubernetes-addons creation

module "aws_load_balancer_controller" {
  count = var.enable_aws_load_balancer_controller ? 1 : 0
  depends_on = [
    data.aws_eks_cluster_auth.example
  ]
  eks_cluster_endpoint = var.eks_cluster_endpoint
  source               = "../aws-load-balancer-controller"
  helm_config          = var.aws_load_balancer_controller_helm_config
  eks_cluster_id       = var.eks_cluster_id
  addon_context        = merge(local.addon_context, { default_repository = local.amazon_container_image_registry_uris[data.aws_region.current.name] })
  vpc_id               = data.aws_ssm_parameter.vpc_id.value
}

module "coredns_autoscaler" {
  count         = var.enable_coredns_autoscaler && length(var.coredns_autoscaler_helm_config) > 0 ? 1 : 0
  source        = "../cluster-proportional-autoscaler"
  helm_config   = var.coredns_autoscaler_helm_config
  addon_context = local.addon_context
}

module "cluster_autoscaler" {
  source              = "../cluster-autoscaler"
  count               = var.enable_cluster_autoscaler ? 1 : 0
  eks_cluster_version = local.eks_cluster_version
  helm_config         = var.cluster_autoscaler_helm_config
  addon_context       = local.addon_context
}

module "external_dns" {
  source            = "../external-dns"
  count             = var.enable_external_dns ? 1 : 0
  helm_config       = var.external_dns_helm_config
  irsa_policies     = var.external_dns_irsa_policies
  addon_context     = local.addon_context
  domain_env        = var.eks_domain_env
  private_zone      = var.external_dns_private_zone
  route53_zone_arns = var.external_dns_route53_zone_arns
  external_dns_role = var.external_dns_role

}

module "enable_cni_metrics_helper" {
  count         = var.enable_cni_metrics_helper ? 1 : 0
  source        = "../cni-metrics-helper"
  helm_config   = var.cni_metrics_helper_templates_helm_config
  addon_context = local.addon_context
}

module "metrics_server" {
  count         = var.enable_metrics_server ? 1 : 0
  source        = "../metrics-server"
  helm_config   = var.metrics_server_helm_config
  addon_context = local.addon_context

}

module "kube_state_metrics" {
  count         = var.enable_kube_state_metrics ? 1 : 0
  source        = "../kube-state-metrics"
  helm_config   = var.kube_state_metrics_helm_config
  addon_context = local.addon_context

}



module "enable_efs_csi_driver" {
  count         = var.enable_aws_efs_csi_driver ? 1 : 0
  source        = "../aws-efs-csi-driver"
  helm_config   = var.efs_csi_driver_templates_helm_config
  addon_context = local.addon_context

}

module "enable_ebs_csi_driver" {
  count         = var.enable_self_managed_aws_ebs_csi_driver ? 1 : 0
  source        = "../aws-ebs-csi-driver"
  helm_config   = var.ebs_csi_driver_templates_helm_config
  addon_context = local.addon_context

}

module "fargate-efs" {
  count                     = var.enable_fargate_efs ? 1 : 0
  source                    = "../fargate-efs"
  eks_cluster_id            = var.eks_cluster_id
  tags                      = var.tags
  parameter_vpc_id_name     = var.parameter_vpc_id_name
  parameter_subnet_id1_name = var.parameter_subnet_id1_name
  parameter_subnet_id2_name = var.parameter_subnet_id2_name
  aws_kms_key_arn           = var.aws_kms_key_arn
  efsvolumeid               = var.efsvolumeid
}

module "twistlock_defender" {
  count          = var.enable_prisma_twistlock_defender ? 1 : 0
  source         = "../twistlock-defender"
  eks_cluster_id = var.eks_cluster_id

}

module "aws_for_fluent_bit" {
  count                    = var.enable_aws_for_fluentbit ? 1 : 0
  source                   = "../aws-for-fluentbit"
  helm_config              = var.aws_for_fluentbit_helm_config
  irsa_policies            = var.aws_for_fluentbit_irsa_policies
  cw_log_group_name        = var.aws_for_fluentbit_cw_log_group_name
  cw_log_group_retention   = var.aws_for_fluentbit_cw_log_group_retention
  cw_log_group_kms_key_arn = var.aws_for_fluentbit_cw_log_group_kms_key_arn
  addon_context            = local.addon_context
}

module "enable_external_secrets" {
  count           = var.enable_external_secrets ? 1 : 0
  source          = "../external-secrets"
  helm_config     = var.external_sercrets_templates_helm_config
  addon_context   = local.addon_context
  aws_kms_key_arn = var.aws_kms_key_arn
  tags            = var.tags
}

module "fargate_fluentbit" {
  count           = var.enable_fargate_fluentbit ? 1 : 0
  source          = "../fargate-fluentbit"
  addon_config    = var.fargate_fluentbit_addon_config
  addon_context   = local.addon_context
  aws_kms_key_arn = var.aws_kms_key_arn
}

module "fargate-insights" {
  count         = var.enable_fargate_insights ? 1 : 0
  source        = "../fargate-insights"
  addon_context = local.addon_context
  tags          = var.tags

}

module "container-insights" {
  count         = var.enable_aws_cloudwatch_metrics ? 1 : 0
  source        = "../aws-cloudwatch-metrics"
  addon_context = local.addon_context
  helm_config   = var.aws_cloudwatch_metrics_helm_config

}

module "eks_cloudwatch_dashboard_and_alerts" {
  count                = var.create_eks_dashboard ? 1 : 0
  source               = "../dashboard-alerts"
  aws_region           = var.aws_region
  cluster_dimensions   = var.cluster_dimensions
  pod_dimensions       = var.pod_dimensions
  create_eks_dashboard = var.create_eks_dashboard
  namespace_dimensions = var.namespace_dimensions
  service_dimensions   = var.service_dimensions
  endpoint             = var.endpoint
  sns-topic            = var.sns-topic
  eks_cluster_id       = var.eks_cluster_id
  tags                 = var.tags

}

module "fargate-dashboards" {
  count         = var.create_fargatecloudwatch_dashboards ? 1 : 0
  source        = "../fargate-dashboards"
  addon_context = local.addon_context

}

module "fargate-alarms" {
  count                     = var.create_fargatecloudwatch_alarms ? 1 : 0
  source                    = "../fargate-alarms"
  addon_context             = local.addon_context
  sns-topic                 = var.sns-topic
  cpu-evaluation-periods    = var.cpu-evaluation-periods
  fargate-cpu-threshold     = var.fargate-cpu-threshold
  network-evaluation-period = var.network-evaluation-period
  network-threshold         = var.network-threshold
  mem-evaluation-periods    = var.mem-evaluation-periods
  fargate-mem-threshold     = var.fargate-mem-threshold

}