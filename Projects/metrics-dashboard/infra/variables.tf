variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "docker_image" {
  description = "Docker image for backend"
  type        = string
}

variable "docker_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "subnets" {
  description = "Subnets for ECS service"
  type        = list(string)
}

variable "security_group" {
  description = "Security group ID for ECS tasks"
  type        = string
}
