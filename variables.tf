variable "aws_region" {
  description = "AWS region used for every resource in this experiment."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix applied to every resource."
  type        = string
  default     = "exp3-iac-ci"
}

variable "vpc_cidr" {
  description = "CIDR block of the experiment VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block of the public subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block of the private subnet."
  type        = string
  default     = "10.20.2.0/24"
}

variable "admin_cidr" {
  description = "CIDR block permitted to reach SSH on the application host."
  type        = string
  default     = "10.20.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type for the application host."
  type        = string
  default     = "t3.micro"
}
