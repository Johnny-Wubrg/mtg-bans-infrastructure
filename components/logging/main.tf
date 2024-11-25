resource "aws_cloudwatch_log_group" "mtg_bans" {
  name = "awslogs-mtg-bans"

  tags = {
    Environment = var.environment
    Application = "mtg-bans"
  }
}
