output "rds_hostname" {
  description = "RDS instance hostname"
  value       = module.mtg_bans_rds.hostname
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.mtg_bans_rds.port
  sensitive   = true
}

output "rds_connection_string" {
  value       = local.connection_string
  sensitive   = true
}

output "ecr_registry" {
  description = "ECR registry ID"
  value       = module.mtg_bans_ecr.registry
}

output "ecr_name" {
  description = "ECR repository name"
  value       = module.mtg_bans_ecr.name
}

output "ecr_url" {
  description = "ECR repository URL"
  value       = module.mtg_bans_ecr.url
}
