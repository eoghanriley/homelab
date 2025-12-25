output "vault_address" {
  value = var.vault_address
}

output "foundry_role_created" {
  value = vault_kubernetes_auth_backend_role.foundry.role_name
}

output "foundry_policy_created" {
  value = vault_policy.foundry.name
}