# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-2"
}

variable "environment" {
  type        = string
  description = "The environment"
  default     = "production"
}

variable "db_username" {
  type        = string
  description = "RDS root username"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "RDS root user password"
  sensitive   = true
}

variable "db_whitelist" {
  type        = list(string)
  description = "IP Addresses to allow access to RDS instance"
  default     = ["0.0.0.0/0"] # Default IPs
}

variable "api_key" {
  type        = string
  description = "API Key for writing to API"
  sensitive   = true
}

variable "image_version" {
  type = string
  description = "The version of the image to deploy"
  default = "latest"
}