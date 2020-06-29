variable "terraform_state_bucket" {
  type = string
}

variable "github_scope" {
  type = string
}

variable "github_pat" {
  description = "Personal Access Token used to access game's GitHub repository (sensitive)"
  type        = string
}

variable "image" {
  type    = string
  default = "windows-server-2019-dc-core-v20200512"
}

variable "machine_type" {
  type    = string
  default = "n1-standard-4"
}

variable "boot_disk_size" {
  type    = number
  default = 200
}