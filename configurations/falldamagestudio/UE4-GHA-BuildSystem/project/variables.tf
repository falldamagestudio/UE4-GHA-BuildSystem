variable "project_id" {
  description = "ID for the GCP project that will contain the build system."
  type        = string
}

variable "region" {
  description = "GCE region where region-bound resources will be created. See https://cloud.google.com/compute/docs/regions-zones for details."
  type        = string
}

variable "zone" {
  description = "GCE zone where zone-bound resources will be created. See https://cloud.google.com/compute/docs/regions-zones for details."
  type        = string
}
