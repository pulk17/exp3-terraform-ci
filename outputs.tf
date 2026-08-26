output "vpc_id" {
  description = "Identifier of the experiment VPC."
  value       = module.network.vpc_id
}

output "app_instance_id" {
  description = "Identifier of the application host."
  value       = module.compute.instance_id
}

output "app_public_ip" {
  description = "Elastic IP address attached to the application host."
  value       = module.compute.public_ip
}
