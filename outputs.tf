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
