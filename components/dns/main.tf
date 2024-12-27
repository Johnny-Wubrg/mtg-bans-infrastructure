resource "aws_route53_zone" "mtg_bans" {
  name = var.domain
}

locals {
  api_hostname = "api.${var.domain}"
}

resource "aws_route53_record" "mtg_bans_api_record" {
  zone_id = aws_route53_zone.mtg_bans.zone_id
  name    = local.api_hostname
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "mtg_bans_api" {
  domain_name       = local.api_hostname
  validation_method = "DNS"

  tags = {
    name = "${local.api_hostname} SSL Certificate"
  }
}

resource "aws_route53_record" "mtg_bans_api_validation" {
  for_each = {
    for dvo in aws_acm_certificate.mtg_bans_api.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = aws_route53_zone.mtg_bans.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  allow_overwrite = true
  ttl             = 60
}

resource "aws_acm_certificate_validation" "mtg_bans_api_validation" {
  timeouts {
    create = "5m"
  }
  certificate_arn         = aws_acm_certificate.mtg_bans_api.arn
  validation_record_fqdns = [for record in aws_route53_record.mtg_bans_api_validation : record.fqdn]
}

resource "aws_lb_listener_certificate" "mtg_bans_api" {
  listener_arn    = var.alb_listener_arn
  certificate_arn = aws_acm_certificate.mtg_bans_api.arn

  depends_on = [
    aws_acm_certificate.mtg_bans_api,
    aws_acm_certificate_validation.mtg_bans_api_validation
  ]
}
