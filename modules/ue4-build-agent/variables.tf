
variable "name" {
    type = string
}

variable "image" {
    type = string
}

variable "machine_type" {
    type = string
    default = "n1-standard-1"
}

variable "zone" {
    type = string
    default = null
}

variable "project_id" {
    type = string
    default = null
}

variable "boot_disk_size" {
    type = number
}

variable "metadata" {
    type = map
    default = {}
}