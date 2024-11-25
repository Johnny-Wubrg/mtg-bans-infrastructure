output "registry" {
  description = "ECR registry ID"
  value = aws_ecr_repository.repo.registry_id
}

output "name" {
  description = "ECR repository name"
  value = aws_ecr_repository.repo.name
}

output "url" {
  description = "ECR repository URL"
  value = aws_ecr_repository.repo.repository_url
}
