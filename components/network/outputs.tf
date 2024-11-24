output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "subnet_group" {
  description = "Name of the subnet group"
  value       = aws_db_subnet_group.mtg_bans.name
}
