/*
 * # Terraform usage example which creates eks multiple node groups in AWS
 * This module will create eks managed groups for ec2 instances.
*/
# Filename     : eks-modules/aws/modules/eks/examples/eks-nodegroups/main.tf
#  Date        : 26 May 2022
#  Author      : Trianz
#  Description : eks-node group creation

#### Cluster Locals ########
locals {
  AppID              = var.AppID
  Environment        = var.Environment
  DataClassification = var.DataClassification
  CRIS               = var.CRIS
  Notify             = var.Notify
  Owner              = var.Owner
  Compliance         = var.Compliance

}

#### Tags module ########
module "tags" {
  source             = "../../../tags"
  AppID              = local.AppID
  Environment        = local.Environment
  DataClassification = local.DataClassification
  CRIS               = local.CRIS
  Notify             = local.Notify
  Owner              = local.Owner
  Compliance         = local.Compliance
}



## EKS  Module #####
module "eks" {

  source                          = "../../modules/eks-nodegroup"
  cluster_name                    = var.cluster_name
  role_service                    = var.role_service
  node_groups                     = var.node_groups
  aws_kms_key_arn                 = var.aws_kms_key_arn
  parameter_subnet_id1_name       = var.parameter_subnet_id1_name
  parameter_subnet_id2_name       = var.parameter_subnet_id2_name
  parameter_subnet_id3_name       = var.parameter_subnet_id3_name
  parameter_vpc_id_name           = var.parameter_vpc_id_name
  role_service_managed            = var.role_service_managed
  root_block_size                 = var.root_block_size
  kube_proxy                      = var.kube_proxy
  vpcni                           = var.vpcni
  k8s-version                     = var.k8s-version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  tags                            = module.tags.tags
}

 
module "eks_kubernetes_addons" {
  depends_on = [module.aws_eks_rbac]
  source     = "../../modules/kubernetes-addons"

  #These are the details related to the individual eks cluster
  parameter_vpc_id_name              = var.parameter_vpc_id_name
  parameter_subnet_id1_name          = var.parameter_subnet_id1_name
  parameter_subnet_id2_name          = var.parameter_subnet_id2_name
  parameter_subnet_id3_name          = var.parameter_subnet_id3_name
  eks_cluster_id                     = module.eks.cluster_id
  eks_cluster_endpoint               = module.eks.cluster_endpoint
  eks_oidc_provider                  = module.eks.oidc_provider
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data

  eks_cluster_version = var.k8s-version

  #addons 
  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  enable_coredns_autoscaler           = var.enable_coredns_autoscaler
  coredns_autoscaler_helm_config = {
    name      = "cluster-proportional-autoscaler"
    chart     = "cluster-proportional-autoscaler"
    version   = "1.0.0"
    namespace = "kube-system"
    timeout   = "300"
    values = [templatefile("${path.module}/helm_values/coredns-autoscaler-values.yaml", {
      operating_system = "linux"
      target           = "deployment/coredns"
    })]
    description = "Cluster Proportional Autoscaler for CoreDNS Service"
  }
  aws_kms_key_arn               = var.aws_kms_key_arn
  enable_aws_cloudwatch_metrics = var.enable_aws_cloudwatch_metrics
  create_eks_dashboard          = var.create_eks_dashboard
  cluster_dimensions            = var.cluster_dimensions
  pod_dimensions                = var.pod_dimensions
  namespace_dimensions          = var.namespace_dimensions
  service_dimensions            = var.service_dimensions
  aws_region                    = var.aws_region
  endpoint                      = var.Notify
  efsvolumeid                   = var.efsvolumeid
  enable_cni_metrics_helper     = var.enable_cni_metrics_helper
  enable_aws_efs_csi_driver     = var.enable_aws_efs_csi_driver
  enable_external_dns           = var.enable_external_dns
  external_dns_role             = var.external_dns_role
  eks_domain_env                = var.eks_domain_env

  enable_self_managed_aws_ebs_csi_driver = var.enable_self_managed_aws_ebs_csi_driver
  ebs_csi_driver_templates_helm_config = {
    kubernetes_version = var.k8s-version
  }
  external_sercrets_templates_helm_config = {
    create_namespace = false
  }

  enable_aws_for_fluentbit                 = var.enable_aws_for_fluentbit
  aws_for_fluentbit_cw_log_group_retention = 30

  aws_for_fluentbit_helm_config = {
    name             = "aws-for-fluent-bit"
    chart            = "aws-for-fluent-bit"
    version          = "0.1.18"
    namespace        = "logging"
    create_namespace = true
    values = [templatefile("${path.module}/helm_values/aws-for-fluentbit-values.yaml", {
      region                                     = var.aws_region
      aws_for_fluent_bit_cw_log_group            = "/${module.eks.cluster_id}/application-logs"
      aws_for_fluentbit_cw_log_group_kms_key_arn = var.aws_kms_key_arn
      cluster_name                               = module.eks.cluster_id
    })]
    set = [
      {
        name  = "nodeSelector.kubernetes\\.io/os"
        value = "linux"
      }
    ]
  }

  enable_prisma_twistlock_defender = var.enable_prisma_twistlock_defender
  enable_cluster_autoscaler        = var.enable_cluster_autoscaler
  enable_metrics_server            = var.enable_metrics_server
  enable_kube_state_metrics        = var.enable_kube_state_metrics
  enable_external_secrets          = var.enable_external_secrets
  sns-topic                        = var.sns-topic
  tags                             = module.tags.tags

}


module "aws_eks_rbac" {
  depends_on           = [module.eks]
  source               = "../../modules/rbac"
  eks_cluster_id       = module.eks.cluster_id
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_provider    = module.eks.oidc_provider
  fargate_type         = var.fargate_type
  #  managed_role_group_iam = var.role_name_managed
  managed_node_groups                = var.managed_node_groups
  application_team_role              = var.application_team_role
  readonly_roles                     = var.readonly_roles
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  create_aws_auth_configmap          = var.create_aws_auth_configmap
  tags                               = module.tags.tags
  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/CloudAdmin"
      username = "Cloudadmin"
      groups   = ["system:masters"]
    }
  ]
  map_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/mahender.tirumala@tekyantra.com"
      username = "mahender.tirumala@tekyantra.com"
      groups   = ["system:masters"]

    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/shoban.ch@tekyantra.com"
      username = "shoban.ch@tekyantra.com"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/suresh.banyala@tekyantra.com"
      username = "suresh.banyala@tekyantra.com"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/chiranjeevi.gajjeli@tekyantra.com"
      username = "chiranjeevi.gajjeli@tekyantra.com"
      groups   = ["system:masters"]
    }
  ]


  platform_teams = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${join("-", [module.eks.cluster_id, "codebuild"])}"]


  application_teams = {
    team-alpha = {
      "labels" = {
        "appName"     = "alpha-team-app",
        "projectName" = "project-alpha",
        "environment" = "example",
        "domain"      = "example",
        "uuid"        = "example",
        "billingCode" = "example",
        "branch"      = "example"
      }
      "quota" = {
        "requests.cpu"    = "1000m",
        "requests.memory" = "4Gi",
        "limits.cpu"      = "2000m",
        "limits.memory"   = "8Gi",
        "pods"            = "10",
        "secrets"         = "10",
        "services"        = "10"
      }


      manifests_dir = "./manifests-team-alpha"
      users         = [data.aws_caller_identity.current.arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.application_team_role}"]
    }

    team-beta = {
      "labels" = {
        "appName"     = "beta-team-app",
        "projectName" = "project-beta",
      }
      "quota" = {
        "requests.cpu"    = "2000m",
        "requests.memory" = "4Gi",
        "limits.cpu"      = "4000m",
        "limits.memory"   = "16Gi",
        "pods"            = "20",
        "secrets"         = "20",
        "services"        = "20"
      }

      manifests_dir = "./manifests-team-beta"
      users         = [data.aws_caller_identity.current.arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.application_team_role}"]
    }

  }
}

module "codebuild_iam_role_eks" {
  depends_on       = [module.eks]
  count            = var.create_codebuild_iam_role_eks ? 1 : 0
  source           = "../../modules/codebuild-iam-role"
  eks_cluster_id   = module.eks.cluster_id
  tags             = module.tags.tags
  policy_file_name = var.policy_file_name
}