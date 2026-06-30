output "ecs_service_name" {
  value = aws_ecs_service.app.name
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.main.name
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.main.deployment_group_name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.app.arn
}