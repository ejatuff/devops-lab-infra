terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

/*
Definimos el locals para poder pasar una contrasena al la vm nfs 
ya que la variable password_hash está definida como null para que no la pidan todas las vm. 
*/
locals {
  password_line = var.password_hash != null ? "        passwd: ${var.password_hash}" : ""
  lock_line     = var.password_hash != null ? "        lock_passwd: false" : "        lock_passwd: true"
  ssh_pwauth    = var.password_hash != null ? "true" : "false"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.datastore_id
  node_name    = var.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    users:
      - default
      - name: operador
        groups:
          - sudo
        shell: /bin/bash
${local.lock_line}
${local.password_line}
        sudo: ALL=(ALL) NOPASSWD:ALL
    chpasswd:
      expire: false
    ssh_pwauth: ${local.ssh_pwauth}       

    runcmd:
        - apt update
        - apt install -y qemu-guest-agent net-tools
        - timedatectl set-timezone America/Argentina/La_Rioja
        - systemctl enable qemu-guest-agent
        - systemctl start qemu-guest-agent
        - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "cloud-config.yaml"
  }
}


resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.name
  node_name = var.node_name
  tags      = ["terraform", "lab", var.role]

  clone {
    vm_id = var.vm_id
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.disk_size
  }

  network_device {
    bridge = var.bridge
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ipv4_address != null ? var.ipv4_address : "dhcp"
        gateway = var.ipv4_address != null ? var.ipv4_gateway : null
      }
    }
  }
}