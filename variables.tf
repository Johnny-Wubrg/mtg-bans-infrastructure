# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}

variable "db_whitelist" {
  description = "IP Addresses to allow access to RDS instance"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default IPs
}
