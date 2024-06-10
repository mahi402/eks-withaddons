/*
 * # AWS eks cluster with  managed node group creation
 * This module will create eks and  managed groups.
*/
# Filename     : eks-modules/aws/modules/eks/modules/eks-nodegroup/main.tf
#  Date        : 26 july 2022
#  Author      : TekYantra
#  Description : eks-node group creation

/* IAM Role for EKS Cluster */
module "aws_iam_role" {
  source      = "../../../iam_role"
  
  name        = join("-", [var.cluster_name, "eksservice-role"]) # this is how you can gernerate unique names all the times based on the clustername
  aws_service = var.role_service                                 #default
  tags        = merge(var.tags, { pge_team = local.namespace }, { Name = join("-", [var.cluster_name, "eksservice-role"]) })
  #AWS_Managed_Policy
  policy_arns = distinct(concat(local.default_policy_arns, var.policy_arns))
}

resource "aws_security_group_rule" "cluster_security_group_ingress_rule1" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  cidr_blocks       = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  description       = join("-", [var.cluster_name, "pge-in", "Allow unmanaged nodes to communicate with control plane (443)"])
}

#### Eks Cluster Creation ########
resource "aws_eks_cluster" "eks_cluster" {
  name                      = var.cluster_name
  version                   = var.k8s-version
  role_arn                  = module.aws_iam_role.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  tags                      = merge(var.tags, local.tags, { pge_team = local.namespace })

  encryption_config {
    resources = var.resources
    provider {
      key_arn = var.aws_kms_key_arn
    }
  }
  vpc_config {

    subnet_ids              = [data.aws_ssm_parameter.subnet_id1.value, data.aws_ssm_parameter.subnet_id2.value, data.aws_ssm_parameter.subnet_id3.value]
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = true
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  timeouts {
    create = var.cluster_create_timeout
    delete = var.cluster_delete_timeout
    update = var.cluster_update_timeout
  }

}

## IAM role for NodeGroup  ###
module "aws_iam" {
  source      = "../../../iam_role"
 
  name        = join("-", [var.cluster_name, "workernode-role"])
  aws_service = var.role_service_managed
  tags        = merge(var.tags, { pge_team = local.namespace }, { Name = join("-", [var.cluster_name, "workernode-role"]) })
  #AWS_Managed_Policy
  policy_arns = distinct(concat(local.eks_arns, var.policy_arns))
}

## EKS Managed node group #####
resource "aws_eks_node_group" "eks-nodegroup" {
  for_each               = var.create ? { for ng in var.node_groups : ng.name => ng } : {}
  depends_on             = [aws_eks_cluster.eks_cluster]
  ami_type               = each.value.ami_type
  cluster_name           = aws_eks_cluster.eks_cluster.name
  node_group_name        = each.value.name
  node_group_name_prefix = each.value.name_prefix
  node_role_arn          = module.aws_iam.arn
  subnet_ids             = [data.aws_ssm_parameter.subnet_id1.value, data.aws_ssm_parameter.subnet_id2.value, data.aws_ssm_parameter.subnet_id3.value]
  instance_types         = each.value.instance_types
  disk_size              = var.root_block_size
  tags                   = merge(var.tags, local.tags, { pge_team = local.namespace }, { Name = join("-", [aws_eks_cluster.eks_cluster.name, each.value.name, each.value.type_of_instance, "nodegroup"]) })
  dynamic "launch_template" {
    for_each = each.value.launch_template != null ? [1] : []
    content {
      id      = each.value.launch_template.id
      name    = each.value.launch_template.name
      version = each.value.launch_template.version
    }
  }
  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }
  dynamic "taint" {
    for_each = { for t in coalesce(each.value.taints, []) : join(":", [t.key, coalesce(t.value, "null"), t.effect]) => t }
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }
  labels = each.value.labels
  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  dynamic "update_config" {
    for_each = each.value.update_config != null ? [1] : []
    content {
      max_unavailable            = each.value.update_config.max_unavailable
      max_unavailable_percentage = each.value.update_config.max_unavailable_percentage
    }
  }
}









#### EKS Addons ##########
resource "aws_eks_addon" "addon" {
  depends_on    = [aws_eks_cluster.eks_cluster, aws_eks_node_group.eks-nodegroup]
  addon_name    = var.vpcni
  addon_version = var.addon_version
  cluster_name  = var.cluster_name
  tags          = merge(var.tags, local.tags, { pge_team = local.namespace }, { Name = join("-", [var.cluster_name, "addon-vpcni"]) })
}

resource "aws_eks_addon" "addon-kubeproxy" {
  depends_on    = [aws_eks_cluster.eks_cluster, aws_eks_node_group.eks-nodegroup, aws_eks_addon.addon]
  addon_name    = var.kube_proxy
  addon_version = var.addon_version
  cluster_name  = var.cluster_name
  tags          = merge(var.tags, local.tags, { pge_team = local.namespace }, { Name = join("-", [var.cluster_name, "addon-kubeproxy"]) })
}

data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}