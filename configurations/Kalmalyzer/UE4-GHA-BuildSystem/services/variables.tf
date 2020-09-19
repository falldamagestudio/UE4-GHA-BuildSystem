variable "terraform_state_bucket" {
  description = "Name of GCS bucket that contains all Terraform state files."
  type        = string
}

variable "github_pat" {
  description = "Personal Access Token used to access engine & game repositories in GitHub. Format: 40 characters hex string. NOTE: this should not be set via terraform.tfvars, but passed in via user.auto.tfvars or via the command line."
  type        = string
}

# engine_storage

variable "engine_storage_bucket_name" {
  description = "Name of GCS bucket that will contain all engine build artefacts. The GCS bucket name must be unique across all of Google Cloud. See https://cloud.google.com/storage/docs/naming-buckets for rules."
  type        = string
}

# engine_builders

variable "engine_builder_github_scope" {
  description = "<org>/<repo> portion of the GitHub repository name that contains the engine."
  type        = string
}

variable "engine_builder_image" {
  description = "Name of a VM disk image that will be used when creating the engine builder VM. The image must already have been built with Packer, and exist within the GCP project. NOTE: this should not be set via terraform.tfvars, but passed in via user.auto.tfvars or via the command line."
  type        = string
}

variable "engine_builder_machine_type" {
  description = "GCE instance machine type to use when creating the engine builder VM. See https://cloud.google.com/compute/docs/machine-types for available machine types."
  type        = string
  default     = "n1-standard-4"
}

variable "engine_builder_boot_disk_type" {
  description = "Type of boot disk to use when creating the engine builder VM. See https://cloud.google.com/compute/docs/disks#disk-types for available disk types."
  type        = string
  default     = "pd-ssd"
}

variable "engine_builder_boot_disk_size" {
  description = "Size of boot disk, in GB, to use when creating the engine builder VM."
  type        = number
  default     = 400
}

variable "engine_builder_instance_name" {
  description = "Name of the GCE instance (VM) to create. The VM name must be unique within the GCP project. See https://cloud.google.com/compute/docs/naming-resources#resource-name-format for rules."
  type        = string
}

variable "engine_builder_runner_name" {
  description = "Name of the GitHub Actions runner that will run on the engine builder VM. The runner will also receive a label with the runner name. The runner name must be unique within the GitHub repository for the engine. To avoid problems, use only lowercase letters, numbers, and underscores for the runner name."
  type        = string
}

# engine_watchdog

variable "engine_watchdog_source_bucket_name" {
  description = "Name of GCS bucket that will contain the Cloud Function's source code for the engine watchdog. GCF will fetch code from that bucket when there's a need to spin up internal instances that serve the function. The GCS bucket name must be unique across all of Google Cloud. See https://cloud.google.com/storage/docs/naming-buckets for rules."
  type        = string
}

variable "engine_watchdog_function_name" {
  description = "Name of the Cloud Function that serves as engine watchdog. The function name must be unique across an entire region of Google Cloud."
  type        = string
}

variable "engine_watchdog_github_organization" {
  description = "<org> portion of the GitHub repository name that contains the engine."
  type        = string
}

variable "engine_watchdog_github_repository" {
  description = "<repo> portion of the GitHub repository name that contains the engine."
  type        = string
}

variable "engine_watchdog_scheduling_interval" {
  description = "Number of minutes between each automated invocation of the watchdog. 10 minutes provides a good balance between running often, and avoiding GitHub's API rate limiting. See https://developer.github.com/v3/#rate-limiting for details."
  type        = number
  default     = 10
}

# game_storage

variable "game_storage_bucket_name" {
  description = "Name of GCS bucket that will contain all game build artefacts. The GCS bucket name must be unique across all of Google Cloud. See https://cloud.google.com/storage/docs/naming-buckets for rules."
  type        = string
}

# game_builders

variable "game_builder_github_scope" {
  description = "<org>/<repo> portion of the GitHub repository name that contains the game."
  type        = string
}

variable "game_builder_image" {
  description = "Name of a VM disk image that will be used when creating the game builder VM. The image must already have been built with Packer, and exist within the GCP project. NOTE: this should not be set via terraform.tfvars, but passed in via user.auto.tfvars or via the command line."
  type        = string
}

variable "game_builder_machine_type" {
  description = "GCE instance machine type to use when creating the game builder VM. See https://cloud.google.com/compute/docs/machine-types for available machine types."
  type        = string
  default     = "n1-standard-4"
}

variable "game_builder_boot_disk_type" {
  description = "Type of boot disk to use when creating the game builder VM. See https://cloud.google.com/compute/docs/disks#disk-types for available disk types."
  type        = string
  default     = "pd-ssd"
}

variable "game_builder_boot_disk_size" {
  description = "Size of boot disk, in GB, to use when creating the game builder VM."
  type        = number
  default     = 200
}

variable "game_builder_instance_name" {
  description = "Name of the GCE instance (VM) to create. The VM name must be unique within the GCP project. See https://cloud.google.com/compute/docs/naming-resources#resource-name-format for rules."
  type        = string
}

variable "game_builder_runner_name" {
  description = "Name of the GitHub Actions runner that will run on the game builder VM. The runner will also receive a label with the runner name. The runner name must be unique within the GitHub repository for the game. To avoid problems, use only lowercase letters, numbers, and underscores for the runner name."
  type        = string
}

# game_watchdog

variable "game_watchdog_source_bucket_name" {
  description = "Name of GCS bucket that will contain the Cloud Function's source code for the game watchdog. GCF will fetch code from that bucket when there's a need to spin up internal instances that serve the function. The GCS bucket name must be unique across all of Google Cloud. See https://cloud.google.com/storage/docs/naming-buckets for rules."
  type        = string
}

variable "game_watchdog_function_name" {
  description = "Name of the Cloud Function that serves as game watchdog. The function name must be unique across an entire region of Google Cloud."
  type        = string
}

variable "game_watchdog_github_organization" {
  description = "<org> portion of the GitHub repository name that contains the game."
  type        = string
}

variable "game_watchdog_github_repository" {
  description = "<repo> portion of the GitHub repository name that contains the game."
  type        = string
}

variable "game_watchdog_scheduling_interval" {
  description = "Number of minutes between each automated invocation of the watchdog. 10 minutes provides a good balance between running often, and avoiding GitHub's API rate limiting. See https://developer.github.com/v3/#rate-limiting for details."
  type        = number
}
