
variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type = string
}

variable "zone" {
  description = "The GCP zone to create and test resources in"
  type        = string
}


variable "github_scope" {
  type = string
}

variable "github_pat" {
  type = string
}

# variable "region" {
#   description = "The GCP region to create and test resources in"
#   type        = string
#   default     = "us-central1"
# }

# variable "network" {
#   description = "The network selflink to host the compute instances in"
# }

# variable "num_instances" {
#   description = "Number of instances to create"
# }

# variable "nat_ip" {
#   description = "Public ip address"
#   default     = null
# }

# variable "network_tier" {
#   description = "Network network_tier"
#   default     = "PREMIUM"
# }


# variable "service_account" {
#   default = null
#   type = object({
#     email  = string,
#     scopes = set(string)
#   })
#   description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
# }
