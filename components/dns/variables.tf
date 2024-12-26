variable "domain" {
  type        = string
  description = "Primary application domain"
}

variable "alb_zone_id" {
  type        = string
  description = "Zone ID of the load balancer"
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of the load balancer"
}
