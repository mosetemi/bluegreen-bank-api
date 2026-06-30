output "alb_arn" {
  value = aws_lb.main.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_arn_suffix" {
  value = aws_lb.main.arn_suffix
}

output "blue_tg_arn" {
  value = aws_lb_target_group.blue.arn
}

output "green_tg_arn" {
  value = aws_lb_target_group.green.arn
}

output "blue_tg_name" {
  value = aws_lb_target_group.blue.name
}

output "green_tg_name" {
  value = aws_lb_target_group.green.name
}

output "production_listener_arn" {
  value = aws_lb_listener.production.arn
}

output "test_listener_arn" {
  value = aws_lb_listener.test.arn
}

output "ecs_tasks_sg_id" {
  value = aws_security_group.ecs_tasks.id
}