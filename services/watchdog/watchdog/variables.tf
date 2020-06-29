variable "source_bucket_name" {
  type = string
}

variable "source_bucket_location" {
  description = "The GCS location to create and test resources in"
  type        = string
}

variable "function_name" {
  type = string
}

variable "function_region" {
  type = string
}

variable "source_path" {
  type = string
}

variable "build_agent_project" {
  type = string
}

variable "build_agent_zone" {
  type = string
}

variable "github_pat" {
  type = string
}

variable "github_organization" {
  type = string
}

variable "github_repository" {
  type = string
}

variable "scheduling_interval" {
  type = number
}
