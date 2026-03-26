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
variable "ipv4_address" {
  description = "IPv4 address with CIDR (e.g. 192.168.150.230/24). If null, uses DHCP."
  type        = string
  default     = null
}
variable "ipv4_gateway" {
  description = "IPv4 gateway (required if ipv4_address is set)."
  type        = string
  default     = null
}
variable "password_hash" {
  description = "Hash SHA-512 para la contraseña del usuario"
  type        = string
  sensitive   = true
  default     = null
}