output "hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.mtg_bans.address
  sensitive   = true
}

output "port" {
  description = "RDS instance port"
  value       = aws_db_instance.mtg_bans.port
  sensitive   = true
}
