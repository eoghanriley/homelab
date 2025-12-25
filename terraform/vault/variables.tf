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