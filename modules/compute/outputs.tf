output "instance_id" {
  description = "Identifier of the application host."
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Elastic IP address attached to the application host."
  value       = aws_eip.app.public_ip
}
