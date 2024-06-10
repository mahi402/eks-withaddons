##########efs csi variables##########
variable "storagesize" {
  description = "Efs fargate storage size"
  type        = string
  default     = "5Gi"
}


variable "parameter_vpc_id_name" {
  type        = string
  description = "Id of vpc stored in aws_ssm_parameter"
}
variable "parameter_subnet_id1_name" {
  type        = string
  description = "Name of the subnet id stored in aws_ssm_parameter"
}

variable "parameter_subnet_id2_name" {
  type        = string
  description = "Name of the subnet id stored in aws_ssm_parameter"
}

variable "eks_cluster_id" {
  description = "EKS Cluster ID"
  type        = string

}
variable "efsvolumeid" {
  description = "EFS Volume ID"
  type        = string

}
variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
  type        = map(string)
  default     = {}
}



variable "cidr_ingress_rules" {
  description = "securitygroup rules for efs"
  type = list(object({
    from             = number
    to               = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    description      = string
  }))
  default = [{
    from             = 0,
    to               = 0,
    protocol         = "tcp",
    cidr_blocks      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    ipv6_cidr_blocks = []
    description      = "bootstrap Ingress rules"
    }
  ]
}

variable "cidr_egress_rules" {
  description = "securitygroup rules for efs"
  type = list(object({
    from             = number
    to               = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    description      = string
  }))
  default = [{
    from             = 0,
    to               = 65535,
    protocol         = "tcp",
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    description      = "CCOE egress rules"
    }
  ]
}

variable "aws_kms_key_arn" {
  description = "KMS encryption key for the EKS cluster"
  type        = string

}