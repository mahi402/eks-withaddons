output "role_name" {
  value       = module.codebuild_iam_role.name
  description = "The name of the created role"
}

output "role_id" {
  value       = module.codebuild_iam_role.id
  description = "The stable and unique string identifying the role"
}

output "role_arn" {
  value       = module.codebuild_iam_role.arn
  description = "The Amazon Resource Name (ARN) specifying the code build role"
}