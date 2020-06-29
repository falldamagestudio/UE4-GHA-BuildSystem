variable "terraform_state_bucket" {
  type = string
}

variable "source_bucket_name" {
  type = string
}

variable "function_name" {
  type = string
}

variable "source_path" {
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
