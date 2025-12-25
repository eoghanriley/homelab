# Vault Configuration with Terraform

## Setup

1. Ensure Vault is running:
```bash
   kubectl get pods -n vault
```

2. Port forward to Vault (if not using LoadBalancer):
```bash
   kubectl port-forward -n vault svc/vault 8200:8200 &
```

3. Copy the example tfvars:
```bash
   cp terraform.tfvars.example terraform.tfvars
```

4. Edit `terraform.tfvars` with your actual credentials

5. Initialize and apply:
```bash
   terraform init
   terraform plan
   terraform apply
```

## What this configures

- KV v2 secrets engine at `secret/`
- Kubernetes auth method
- Foundry VTT policy with read access to `secret/foundry/*`
- Kubernetes auth role for `foundry-vtt` service account
- Foundry credentials stored at `secret/foundry/credentials`