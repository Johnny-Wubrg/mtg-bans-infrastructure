resource "aws_security_group" "rds" {
  name   = "mtg_bans_rds"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.whitelist
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
  username               = var.username
  password               = var.password
  db_subnet_group_name   = var.subnet_group
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.mtg_bans.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}
