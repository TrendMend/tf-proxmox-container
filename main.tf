terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = ">=0.46.1"
    }
  #   ansible = {
  #     version = ">=1.1.0"
  #     source  = "ansible/ansible"
  # }
}
}

resource "proxmox_virtual_environment_container" "this" {
  node_name = var.node_name
  description = var.description
  tags = var.tags

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }
    user_account {
      keys = [
        trimspace(file(var.ssh_public_key_file))
      ]
    }
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
  }


  network_interface {
    name = "veth0"
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory_dedicated
    swap = var.memory_swap
  }

  operating_system {
    # Template equals the first non-null argument provided (template passed via input -> default template)
    template_file_id = coalesce(var.template_file_id, proxmox_virtual_environment_download_file.lxc-debian-12.id)
    type             = var.os_type
  }

  features {
    nesting = var.nesting
  }
}


# Used when template isn't set
resource "proxmox_virtual_environment_download_file" "lxc-debian-12" {
  content_type = "vztmpl"
  datastore_id = var.datastore_id
  node_name    = var.node_name
  url     =  "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.tar.xz"
  overwrite =  "true"
}
