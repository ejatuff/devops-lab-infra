variable "name" {}
variable "node_name" {}
variable "vm_id" {}
variable "cores" {}
variable "memory" {}
variable "disk_size" {}
variable "bridge" {}
variable "datastore_id" {}
variable "role" {
  description = "Rol del nodo (bastion, master, worker)"
  type        = string
}
