variable "project_name" {
  description = "Name prefix applied to every resource in this module."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the experiment VPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block of the public subnet."
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block of the private subnet."
  type        = string
}

variable "admin_cidr" {
  description = "CIDR block permitted to reach SSH on the application host."
  type        = string
}
