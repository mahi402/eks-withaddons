locals {
  default_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonSSMFullAccess", "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController", "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
  fargate_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSVPCResourceController", "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess", "arn:aws:iam::aws:policy/CloudWatchFullAccess", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
  common_tags = {
    env    = var.Environment
    appid  = var.AppID
    region = var.aws_region
  }

  #####for core dns patching
  allowlambda_sg_ingress_rules = [{
    from                     = 0,
    to                       = 65535,
    protocol                 = "tcp",
    source_security_group_id = module.coredns_bootstrap_sg.sg_id,
    description              = "CCOE Ingress rules",
    }
  ]
  allowlambda_cidr_egress_rules = [{
    from             = 0,
    to               = 65535,
    protocol         = "tcp",
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    description      = "CCOE egress rules"
    }
  ]

  bootstrap_sg_ingress_rules = [{
    from             = 0,
    to               = 0,
    protocol         = "tcp",
    cidr_blocks      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    ipv6_cidr_blocks = []
    description      = "bootstrap Ingress rules"
    }
  ]
  bootstrap_cidr_egress_rules = [{
    from             = 0,
    to               = 65535,
    protocol         = "tcp",
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    description      = "bootstrap egress rules"
    }
  ]


  cluster-name = var.cluster_name
  namespace    = "ccoe-tf-developers"


  fargate_default_profiles = {


    kube-system = {
      name = "kube-system"
      selectors = [
        {
          namespace = "kube-system"

        }
      ]
      tags = merge(local.common_tags, tomap({ Namespace = "kube-system" }))
      timeouts = {
        create = "20m"
        delete = "20m"
      }
    },
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"

        }
      ]
      tags = merge(local.common_tags, tomap({ Namespace = "Default" }))
      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }

  }

  fargate_profiles = {

    app = {
      name = "app-wildcard"
      selectors = [
        {
          namespace = "app-*"

        }
      ]
      tags = merge(local.common_tags, tomap({ Namespace = "app" }))
      timeouts = {
        create = "20m"
        delete = "20m"
      }
    },

    container-insights = {
      name = "fargate-container-insights"
      selectors = [
        {
          namespace = "fargate-container-insights"
          labels = {
            app       = "aws-adot",
            component = "adot-collector"

          }
        }
      ]
      tags = merge(local.common_tags, tomap({ Namespace = "container-insights" }))
      timeouts = {
        create = "20m"
        delete = "20m"
      }
    },
    fluent-bit = {
      name = "fluent-bit"
      selectors = [
        {
          namespace = "aws-observability"
          labels = {
            "aws-observability" = "enabled"

          }
        }
      ]
      tags = merge(local.common_tags, tomap({ Namespace = "fluent-bit" }))
      timeouts = {
        create = "20m"
        delete = "20m"
      }
    },
    external-dns = {
      name = "external-dns"
      selectors = [
        {
          namespace = "external-dns"
          labels = {
            "app.kubernetes.io/name" = "external-dns"
          }
        }
      ]
      tags     = merge(local.common_tags, tomap({ Namespace = "external-dns" }))
      timeouts = {}
    },

    external-secrets = {
      name = "external-secrets"
      selectors = [
        {
          namespace = "external-secrets"
          labels = {
            "app.kubernetes.io/instance" = "external-secrets"

          }
        }
      ]
      tags = merge(local.common_tags, tomap({ Namespace = "external-secrets" }))
      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
  }
}

###########for RBAC########################

locals {
  tags = {
    "k8s.io/cluster-autoscaler/enabled"             = true
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = true
    "kubernetes.io/cluster/${var.cluster_name}"     = "owned"
  }
}
