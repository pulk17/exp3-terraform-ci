variable "project_name" {
  description = "Name prefix applied to every resource in this module."
  type        = string
}

variable "subnet_id" {
  description = "Identifier of the subnet the application host is placed in."
  type        = string
}

variable "security_group_id" {
  description = "Identifier of the security group attached to the application host."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the application host."
  type        = string
}
