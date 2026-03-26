terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${var.proxmox_api_user}=${var.proxmox_api_token}"
  insecure  = var.proxmox_api_tls_insecure
}

module "bastion" {
  source       = "./modules/vm"
  providers    = { proxmox = proxmox }
  name         = "bastion-01"
  role         = "bastion"
  node_name    = "pve"
  vm_id        = 9000
  cores        = 1
  memory       = 1024
  disk_size    = 8
  bridge       = "vmbr0"
  datastore_id = "local-lvm"
}

module "master" {
  source       = "./modules/vm"
  providers    = { proxmox = proxmox }
  name         = "k8s-master-01"
  role         = "k8s-master-01"
  node_name    = "pve"
  vm_id        = 9000
  cores        = 2
  memory       = 2048
  disk_size    = 10
  bridge       = "vmbr0"
  datastore_id = "local-lvm"
}

module "worker1" {
  source       = "./modules/vm"
  providers    = { proxmox = proxmox }
  name         = "k8s-worker-01"
  role         = "k8s-worker-01"
  node_name    = "pve"
  vm_id        = 9000
  cores        = 2
  memory       = 2048
  disk_size    = 10
  bridge       = "vmbr0"
  datastore_id = "local-lvm"
}

module "nfs" {
  source    = "./modules/vm"
  providers = { proxmox = proxmox }
  name      = "nfs-01"
  role      = "nfs"
  node_name = "pve"
  vm_id     = 9000
  cores     = 2
  memory    = 2048
  disk_size = 50
  bridge       = "vmbr0"
  datastore_id = "local-lvm"
  password_hash = var.password_hash

/*  ipv4_address = ""
  ipv4_gateway = "192.168.150.1"
*/
}