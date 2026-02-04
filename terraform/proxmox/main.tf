terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://192.168.150.127:8006/api2/json"
  api_token = "terraform@pve!terraform-token=af827ede-db2e-4afa-bdd9-98ab88e376d8"
  insecure  = true
}

module "bastion" {
  source       = "./modules/vm"
  providers = {proxmox = proxmox}
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
  providers = {proxmox = proxmox}
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
  providers = {proxmox = proxmox}
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
