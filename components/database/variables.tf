# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "username" {
  description = "RDS root username"
  sensitive   = true
}

variable "password" {
  description = "RDS root user password"
  sensitive   = true
}

variable "whitelist" {
  description = "IP Addresses to allow access to RDS instance"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default IPs
}
