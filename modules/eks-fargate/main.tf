/*
 * # AWS eks fargate module creating.
 * This module will create eks fargate profile for containers.
*/
# Filename     : eks-modules/aws/modules/eks/examples/eks-fargate/main.tf
#  Author      : TekYantra
#  Description : eks-fargate profile creation 


########SEcurity to group rule to point to PGE corporate network#############

resource "aws_security_group_rule" "cluster_security_group_ingress_rule1" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  security_group_id = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id
  description       = join("-", [var.cluster_name, "sg_i_1", "Allow unmanaged nodes to communicate with control plane (443)"])
}


resource "aws_security_group_rule" "cluster_security_group_ingress_rule2" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 10250
  protocol                 = "-1"
  description              = "Allow unmanaged nodes to communicate with control plane (all ports)"
  source_security_group_id = module.coredns_allowlambda_sg.sg_id
  security_group_id        = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id
}

### Default tags for eks cluster and managed node groups###

module "aws_iam_role" {
  source      = "../../../iam_role"
  
  name        = join("-", [local.cluster-name, "eksservice-role"]) # this is how you can gernerate unique names all the times based on the clustername
  aws_service = ["eks.amazonaws.com"]
  tags        = merge(var.tags, { pge_team = local.namespace }, { Name = join("-", [var.cluster_name, "eksservice-role"]) })


  # #AWS_Managed_Policy
  policy_arns = distinct(concat(local.default_policy_arns, var.policy_arns))
}

resource "aws_security_group" "eks-add-sg" {
 name  = "eks-add-sg"
 vpc_id = data.aws_ssm_parameter.vpc_id.value
 ingress {
  from_port = 443
  to_port  = 443
  protocol = "tcp"
 }
 tags  = merge(var.tags, local.tags, { pge_team = local.namespace }, { Name = join("-", [var.cluster_name, "additional-sg"]) })
}

#### EKS CLUSTER ########
resource "aws_eks_cluster" "eks-cluster" {
  name                      = var.cluster_name
  version                   = var.k8s-version
  role_arn                  = module.aws_iam_role.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  tags                      = merge(var.tags, { pge_team = local.namespace })

  encryption_config {
    resources = var.resources
    provider {
      key_arn = var.aws_kms_key_arn
    }
  }
  vpc_config {
    subnet_ids              = [data.aws_ssm_parameter.subnet_id1.value, data.aws_ssm_parameter.subnet_id2.value, data.aws_ssm_parameter.subnet_id3.value]
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    security_group_ids   = [aws_security_group.eks-add-sg.id]
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }
  depends_on = [module.aws_iam_role.arn]

  timeouts {
    create = var.cluster_create_timeout
    delete = var.cluster_delete_timeout
  }

}

#### addons eks ##########
resource "aws_eks_addon" "addon-vpccni" {
  addon_name    = var.vpcni
  addon_version = var.addon_version
  cluster_name  = aws_eks_cluster.eks-cluster.name
  tags          = merge(var.tags, local.tags, { pge_team = local.namespace })
}


resource "aws_eks_addon" "addon-kubeproxy" {
  addon_name    = var.kube_proxy
  addon_version = var.addon_version
  cluster_name  = aws_eks_cluster.eks-cluster.name
  tags          = merge(var.tags, local.tags, { pge_team = local.namespace })
}

##################### Fargate profile #############
module "aws_iam_fargate" {
  source      = "../../../iam_role"
  #version     = "0.0.4"
  name        = join("-", [var.cluster_name, "fargate-role"])
  aws_service = var.role_service_fargate
  tags        = merge(var.tags, { pge_team = local.namespace }, { Name = join("-", [var.cluster_name, "fargate-role"]) })

  #AWS_Managed_Policy
  policy_arns = distinct(concat(local.fargate_policy_arns, var.policy_arns))
}

### Creating EKS Fargate Profile  for coredns,alb kubesystem's only###
#######Tags, and Labels are optional###########

resource "aws_eks_fargate_profile" "fargate-kube-system" {
  depends_on             = [aws_eks_cluster.eks-cluster]
  for_each               = { for k, v in local.fargate_default_profiles : k => v }
  cluster_name           = aws_eks_cluster.eks-cluster.name
  fargate_profile_name   = each.value.name
  pod_execution_role_arn = module.aws_iam_fargate.arn
  subnet_ids             = [data.aws_ssm_parameter.subnet_id1.value, data.aws_ssm_parameter.subnet_id2.value, data.aws_ssm_parameter.subnet_id3.value]
  tags                   = merge(var.tags, { pge_team = local.namespace })


  dynamic "selector" {
    for_each = each.value.selectors
    content {
      namespace = selector.value.namespace

      labels = lookup(selector.value, "labels", {})
    }
  }
}

#########Fargate profile for Default,twistlock,external-dns profiles###############
#########tags and labels are optionals###############################

resource "aws_eks_fargate_profile" "fargate-default" {
  depends_on             = [time_sleep.wait_profile_active]
  for_each               = { for k, v in local.fargate_profiles : k => v }
  cluster_name           = aws_eks_cluster.eks-cluster.name
  fargate_profile_name   = each.value.name
  pod_execution_role_arn = module.aws_iam_fargate.arn
  subnet_ids             = [data.aws_ssm_parameter.subnet_id1.value, data.aws_ssm_parameter.subnet_id2.value, data.aws_ssm_parameter.subnet_id3.value]
  tags                   = merge(var.tags, { pge_team = local.namespace })


  dynamic "selector" {
    for_each = each.value.selectors
    content {
      namespace = selector.value.namespace

      labels = lookup(selector.value, "labels", {})
    }
  }

  timeouts {
    create = "60m"
    delete = "60m"
  }

}

#######################CoreDNS patch throuhg lamba####################################

#######sg attached to cluster for allowing lambda###########
module "coredns_allowlambda_sg" {
  source                       = "../../../security-group"
  #version                      = "0.0.3"
  name                         = join("-", [var.cluster_name, "coredns-sg"])
  description                  = "Security group for usage with coredns patching using lambda"
  vpc_id                       = data.aws_ssm_parameter.vpc_id.value
  security_group_ingress_rules = local.allowlambda_sg_ingress_rules
  cidr_egress_rules            = local.allowlambda_cidr_egress_rules
  tags                         = merge(var.tags, local.tags, { pge_team = local.namespace }, { Name = join("-", [var.cluster_name, "coredns-sg"]) })
}


############module to attach sg to lambda functionm
module "coredns_bootstrap_sg" {
  source                       = "../../../security-group"
 # version            = "0.0.3"
  name               = join("-", [var.cluster_name, "bootstrap-sg"])
  description        = "Security group for usage core dns with  attached to lambda"
  vpc_id             = data.aws_ssm_parameter.vpc_id.value
  cidr_ingress_rules = local.bootstrap_sg_ingress_rules
  cidr_egress_rules  = local.bootstrap_cidr_egress_rules
  tags               = merge(var.tags, local.tags, { pge_team = local.namespace }, { Name = join("-", [var.cluster_name, "bootstrap-sg"]) })
}

#########iam role for lambda function

module "lambda_iam_role" {
  source      = "../../../iam_role"
  #version     = "0.0.4"
  name        = join("-", [local.cluster-name, "lambda-bootstrap-role"]) # this is how you can gernerate unique names all the times based on the clustername
  aws_service = ["lambda.amazonaws.com"]
  tags        = merge(var.tags, { pge_team = local.namespace }, { Name = join("-", [var.cluster_name, "lambda-bootstrap-role"]) })
  policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
}



data "archive_file" "bootstrap_archive" {
  type        = "zip"
  source_file = "${path.module}/lambda/main.py"
  output_path = "${path.module}/lambda/python.zip"
}

resource "aws_lambda_function" "bootstrap" {
  function_name    = join("-", ["${var.cluster_name}", "bootstrap"])
  runtime          = "python3.7"
  handler          = "main.handler"
  role             = module.lambda_iam_role.arn
  filename         = data.archive_file.bootstrap_archive.output_path
  source_code_hash = data.archive_file.bootstrap_archive.output_base64sha256
  timeout          = 120
  vpc_config {
    subnet_ids         = [data.aws_ssm_parameter.subnet_id1.value, data.aws_ssm_parameter.subnet_id2.value]
    security_group_ids = [module.coredns_bootstrap_sg.sg_id]
  }

}


###To wait or coredns pod to come running state or unauthorized error comes in rbac module
resource "time_sleep" "wait_profile_active" {
  create_duration = "60s"
  depends_on = [
    aws_eks_fargate_profile.fargate-kube-system
  ]
}
############Data blocks to get latest token for lambda execution#############
###########Kubernetes token expires every 15 mins###############

data "aws_eks_cluster" "eks-cluster" {
  name = aws_eks_cluster.eks-cluster.id
  depends_on = [
    time_sleep.wait_profile_active
  ]
}

data "aws_eks_cluster_auth" "eks-cluster-auth" {
  name = aws_eks_cluster.eks-cluster.id
  depends_on = [
    time_sleep.wait_profile_active
  ]
}


##########Lambda execution to path and restart coredns########################
data "aws_lambda_invocation" "bootstrap2" {
  function_name = aws_lambda_function.bootstrap.function_name
  input         = <<JSON
{
  "endpoint": "${data.aws_eks_cluster.eks-cluster.endpoint}",
   "token": "${data.aws_eks_cluster_auth.eks-cluster-auth.token}"
}
JSON

  depends_on = [
    time_sleep.wait_profile_active
  ]

}
