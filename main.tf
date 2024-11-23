terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name                 = "mtg-bans"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "mtg_bans" {
  name       = "mtg_bans"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "MTG Bans"
  }
}


resource "aws_security_group" "rds" {
  name   = "mtg_bans_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.db_whitelist
  }

  tags = {
    Name = "mtg_bans_rds"
  }
}

resource "aws_db_parameter_group" "mtg_bans" {
  name   = "mtg-bans"
  family = "postgres17"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "mtg_bans" {
  identifier             = "mtg-bans"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "17.1"
  username               = "postgres"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.mtg_bans.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.mtg_bans.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}
