variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "The environment"
}

variable "alb_security_group" {
  type        = string
  description = "ID of the ALB security group"
}
variable "alb_target_group_arn" {
  type        = string
  description = "ID of the ALB target group"
}

variable "repository_url" {
  type        = string
  description = "URL to the ECR repository"
}

variable "image_version" {
  type        = string
  description = "The version of the image to deploy"
  default     = "latest"
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

variable "subnets" {
  description = "IDs of the subnets"
  type        = set(string)
}

