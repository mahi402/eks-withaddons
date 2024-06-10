/*
 * # AWS eks cluster with  managed node group creation
 * This module will create eks and  managed groups.
*/
# Filename     : eks-modules/aws/modules/eks/modules/codebuild-iam-role/main.tf
#  Date        : 26 july 2022
#  Author      : TekYantra
#  Description : eks codebuild-iam-role group creation


data "template_file" "codebuild_custom" {
  template = file("${path.module}/policies/${var.policy_file_name}")
  vars = {
    account_num = data.aws_caller_identity.current.account_id
    aws_region  = data.aws_region.current.name
  }
}

module "codebuildiam_policy" {
  source      = "../../../iam_policy"
  
  name        = join("-", [var.eks_cluster_id, "codebuild"])
  description = "IAM Role provisioned for codebuild to talk to eks"
  policy      = [data.template_file.codebuild_custom.rendered]
  tags        = merge(var.tags, { Name = join("-", [var.eks_cluster_id, "codebuild"]) })
}

module "codebuild_iam_role" {
  source      = "../../../iam_role"
  
  name        = join("-", [var.eks_cluster_id, "codebuild"])
  aws_service = ["eks.amazonaws.com", "codebuild.amazonaws.com"]
  tags        = merge(var.tags, { Name = join("-", [var.eks_cluster_id, "codebuild"]) })
  policy_arns = [module.codebuildiam_policy.arn]
}