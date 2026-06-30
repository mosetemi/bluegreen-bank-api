variable "project_name" {
  description = "Name prefix used across all resources"
  type        = string
  default     = "bluegreen-bank"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use for authentication"
  type        = string
  default     = "bluegreen-bank"
}