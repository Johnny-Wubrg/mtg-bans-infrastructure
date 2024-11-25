# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

variable "environment" {
  default     = "production"
  description = "The environment"
}

variable "db_username" {
  description = "RDS root username"
  sensitive   = true
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

variable "api_key" {
  description = "API Key for writing to API"
  type        = string
  sensitive   = true
}
