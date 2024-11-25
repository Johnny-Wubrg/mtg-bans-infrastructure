resource "aws_cloudwatch_log_group" "mtg_bans" {
  name              = "awslogs-mtg-bans"
  retention_in_days = 7

  tags = {
    Environment = var.environment
    Application = "mtg-bans"
  }
}
