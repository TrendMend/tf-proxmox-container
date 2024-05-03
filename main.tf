terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = ">=0.46.1"
    }
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
      keys = concat(var.ssh_public_key_files, [tls_private_key.this_key.public_key_openssh])
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

// Conditionally include provisioner only if var.provision_steps is defined
resource "null_resource" "execute_provision_steps" {
  count = var.provision_steps != null ? 1 : 0

  provisioner "remote-exec" {
    inline = var.provision_steps

    connection {
      host        = split("/", var.ipv4_address)[0]
      type        = "ssh"
      user        = "root"
      private_key = tls_private_key.this_key.private_key_pem
    }
  }
  depends_on = [proxmox_virtual_environment_container.this]
}

resource "tls_private_key" "this_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "random_uuid" "random" {
}

# Used when template isn't set
resource "proxmox_virtual_environment_download_file" "lxc-debian-12" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = var.node_name
  url     =  "http://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
  file_name = "debian-12-${random_uuid.random.result}.tar.zst"
  overwrite =  true
}