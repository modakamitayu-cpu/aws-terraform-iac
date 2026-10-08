variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used in resource naming"
  type        = string
  default     = "terraform-assignment"
}

variable "environment" {
  description = "Environment name such as dev or prod"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "data_volume_size" {
  description = "Secondary EBS volume size in GiB"
  type        = number
  default     = 10
}

variable "snapshot_retention_count" {
  description = "Number of daily EBS snapshots to retain"
  type        = number
  default     = 7
}

variable "enable_asg" {
  description = "Enable bonus Auto Scaling Group"
  type        = bool
  default     = false
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_desired_capacity" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 2
}
