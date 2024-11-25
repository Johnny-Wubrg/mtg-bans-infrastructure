output "container_port" {
  value = local.container_port
  description = "Port the container runs in"
}

output "api_security_group" {
  value = aws_security_group.ecs_tasks.id
  description = "ID of the API security group"
}