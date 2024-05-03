variable "node_name" {
  description = "Name of Proxmox Node"
  type        = string
  default     = "pve"
}

variable "description" {
  description = "Description of the container"
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "Tags for the container"
  type        = list
  default     = ["tf_local_container"]
}

variable "hostname" {
  description = "Hostname of the container"
  type        = string
}

variable "ipv4_address" {
  description = "IPv4 address in the format of 192.168.0.2/24"
  type = string
}

variable "ipv4_gateway" {
  description = "IPv4 gateway in the format of 192.168.0.1"
  type = string
  default = "10.20.0.1"
}

variable "ssh_public_key_file" {
  description = "Public key for root user provided as a string - NOTE: This will be deprecated in favour of ansible & packer generating a public key"
  type = string
}

variable "datastore_id" {
    description = "The desired datastore, such as local or local-lvm"
    type = string
    default = "local"
}

variable "disk_size" {
    description = "Size of the disk in gigabytes"
    type = number
    default = 4
}

variable "cores" {
    description = "Amount of cores"
    type = number
    default = 4
}

variable "memory_dedicated" {
    description = "Amount of dedicated memory in MB"
    type = number
    default = 4096
}

variable "memory_swap" {
    description = "Amount of swap memory in MB"
    type = number
    default = 4096
}

variable "template_file_id" {
    description = "id of the template file"
    type = string
    nullable = true
    default = null
}

variable "os_type" {
    description = "OS type, defaults to debian"
    type = string
    default = "debian"
}

variable "nesting" {
    description = "Bool for nesting"
    type = bool
    default = true
}