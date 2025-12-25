# Get Kubernetes cluster info for Vault auth
data "kubernetes_service" "kubernetes" {
  metadata {
    name      = "kubernetes"
    namespace = "default"
  }
}

# Enable KV v2 secrets engine
resource "vault_mount" "kv" {
  path        = "secret"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

# Enable Kubernetes auth method
resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

# Configure Kubernetes auth backend
resource "vault_kubernetes_auth_backend_config" "config" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = "https://kubernetes.default.svc:443"
  disable_local_ca_jwt = false
}

# Create policy for Foundry VTT
resource "vault_policy" "foundry" {
  name = "foundry-policy"

  policy = <<EOT
path "secret/data/foundry/*" {
  capabilities = ["read", "list"]
}
EOT
}

# Create Kubernetes auth role for Foundry
resource "vault_kubernetes_auth_backend_role" "foundry" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "foundry"
  bound_service_account_names      = ["foundry-vtt"]
  bound_service_account_namespaces = ["foundry-vtt"]
  token_ttl                        = 86400
  token_policies                   = [vault_policy.foundry.name]
}

# Store Foundry credentials in Vault
resource "vault_kv_secret_v2" "foundry_credentials" {
  mount = vault_mount.kv.path
  name  = "foundry/credentials"

  data_json = jsonencode({
    username  = var.foundry_username
    password  = var.foundry_password
    admin_key = var.foundry_admin_key
  })
}