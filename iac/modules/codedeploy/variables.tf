variable "project_name" {
  description = "Name prefix used for tagging and naming resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL for the app image"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ECS cluster ID"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
}

variable "codedeploy_role_arn" {
  description = "ARN of the CodeDeploy service role"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group name for ECS container logs"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_tasks_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "blue_tg_arn" {
  description = "Blue target group ARN"
  type        = string
}

variable "blue_tg_name" {
  description = "Blue target group name"
  type        = string
}

variable "green_tg_name" {
  description = "Green target group name"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch dimensions"
  type        = string
}

variable "production_listener_arn" {
  description = "Production listener ARN (port 80)"
  type        = string
}

variable "test_listener_arn" {
  description = "Test listener ARN (port 8080)"
  type        = string
}