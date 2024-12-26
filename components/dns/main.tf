resource "aws_route53_zone" "mtg_bans" {
  name = var.domain
}

resource "aws_route53_record" "mtg_bans_api_record" {
  zone_id = aws_route53_zone.mtg_bans.zone_id
  name    = "api.${var.domain}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}