
variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "location" {
  description = "The GCS location to create and test resources in"
  type        = string
}

variable "name" {
  type = string
}
