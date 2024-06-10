output "cw_log_group_name" {
  description = "AWS Fluent Bit CloudWatch Log Group Name"
  value       = aws_cloudwatch_log_group.aws_for_fluent_bit.name
}

output "cw_log_group_arn" {
  description = "AWS Fluent Bit CloudWatch Log Group ARN"
  value       = aws_cloudwatch_log_group.aws_for_fluent_bit.arn
}


output "kms-json" {

  description = "data.aws_iam_policy_document.kms.json"
  value       = data.aws_iam_policy_document.kms.json
}