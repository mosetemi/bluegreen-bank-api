terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

backend "s3" {
    bucket = "bluegreen-bank-tf-state"
    key    = "environments/dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
}

module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
}

module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
}

module "codedeploy" {
  source = "./modules/codedeploy"

  project_name               = var.project_name
  aws_region                 = var.aws_region
  ecr_repository_url         = module.ecs.ecr_repository_url
  ecs_cluster_id             = module.ecs.ecs_cluster_id
  ecs_cluster_name           = module.ecs.ecs_cluster_name
  ecs_task_execution_role_arn = module.ecs.ecs_task_execution_role_arn
  ecs_task_role_arn          = module.ecs.ecs_task_role_arn
  codedeploy_role_arn        = module.ecs.codedeploy_role_arn
  cloudwatch_log_group_name  = module.ecs.cloudwatch_log_group_name
  private_subnet_ids         = module.networking.private_subnet_ids
  ecs_tasks_sg_id            = module.alb.ecs_tasks_sg_id
  blue_tg_arn                = module.alb.blue_tg_arn
  blue_tg_name               = module.alb.blue_tg_name
  green_tg_name              = module.alb.green_tg_name
  alb_arn_suffix             = module.alb.alb_arn_suffix
  production_listener_arn    = module.alb.production_listener_arn
  test_listener_arn          = module.alb.test_listener_arn
}