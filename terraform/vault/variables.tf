variable "vault_address" {
  description = "Vault server address"
  type        = string
  default     = "http://localhost:8200"
}

variable "vault_token" {
  description = "Vault root token"
  type        = string
  default     = "root"
  sensitive   = true
}

variable "foundry_username" {
  description = "Foundry VTT username"
  type        = string
  sensitive   = true
}

variable "foundry_password" {
  description = "Foundry VTT password"
  type        = string
  sensitive   = true
}

variable "foundry_admin_key" {
  description = "Foundry VTT admin key"
  type        = string
  sensitive   = true
}

variable "smb_username" {
  description = "SMB/Samba username"
  type        = string
  default     = "k8s-storage"
  sensitive   = true
}

variable "smb_password" {
  description = "SMB/Samba password"
  type        = string
  sensitive   = true
}

variable "smb_server" {
  description = "SMB server address"
  type        = string
  default     = "192.168.86.207"
}

variable "smb_share" {
  description = "SMB share path"
  type        = string
  default     = "/kubernetes"
}