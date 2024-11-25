variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "The environment"
}

variable "repository_url" {
  type        = string
  description = "URL to the ECR repository"
}


variable "connection_string" {
  type        = string
  description = "Connection string to connect to database"
  sensitive   = true
}

variable "api_key" {
  description = "API Key for writing to API"
  sensitive   = true
  type        = string
}

variable "log_group" {
  description = "Name of the log group"
  type        = string
}
