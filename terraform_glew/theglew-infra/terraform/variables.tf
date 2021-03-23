# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS profile used to connect with provider"
  default     = "theglew"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "662235220238.dkr.ecr.us-east-1.amazonaws.com/theglew-backend:latest"
}

variable "email_domain" {
  description = "Default email domain used for SES configuration"
  default     = "noreply@theglew.io"
} 

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8000
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "certificate_arn" {
  description = "ACM theglew.io domain SSL certificate ARN"
  default     = "arn:aws:acm:us-east-1:662235220238:certificate/205bb963-89bf-413f-ac5b-55536eb4ab12" 
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate develop/staging instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "2048"
}

variable "fargate_memory" {
  description = "Fargate develop/staging instance memory to provision (in MiB)"
  default     = "4096"
}

variable "fargate_production_cpu" {
  description = "Fargate production instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "4096"
}

variable "fargate_production_memory" {
  description = "Fargate production instance memory to provision (in MiB)"
  default     = "16384"
}

variable "production_url" {
  description = "URL where production site will be hosted"
  default     = "app.theglew.io"
}

variable "develop_url" {
  description = "URL where develop site will be hosted"
  default     = "dev.theglew.io"
}

variable "staging_url" {
  description = "URL where staging site will be hosted"
  default     = "staging.theglew.io"
}