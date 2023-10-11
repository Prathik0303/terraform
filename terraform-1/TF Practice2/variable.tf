variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.12.0.0/26"
}

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.12.0.0/28", "10.12.0.16/28"]
}

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.12.0.32/28", "10.12.0.48/28"]
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ssh_cidr_block" {
  description = "CIDR block for allowing SSH access"
  type        = string
  default     = "0.0.0.0/0"
}
