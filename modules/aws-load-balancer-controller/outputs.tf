output "ingress_namespace" {
  description = "AWS LoadBalancer Controller Ingress Namespace"
  value       = local.helm_config["namespace"]
}

output "ingress_name" {
  description = "AWS LoadBalancer Controller Ingress Name"
  value       = local.helm_config["name"]
}

