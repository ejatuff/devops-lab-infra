variable "proxmox_api_url" {
  type        = string
}

variable "proxmox_api_user" {
  type        = string
}
variable "proxmox_api_token" {
  type        = string
}
variable "proxmox_api_tls_insecure" {
  type    = bool
  default = true
}
variable "password_hash" {
  description = "Hash SHA-512 para la contraseña del usuario"
  type        = string
  sensitive   = true
  default     = null
}