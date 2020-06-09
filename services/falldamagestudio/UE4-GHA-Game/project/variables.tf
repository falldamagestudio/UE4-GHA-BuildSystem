variable "project_name" {
  type = string
}

variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "org_id" {
  type = string
}

variable "billing_account_id" {
  type = string
}

variable "support_email" {
  type = string
}

variable "application_title" {
  type = string
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
}

variable "zone" {
  description = "The GCP zone to create and test resources in"
  type        = string
}
