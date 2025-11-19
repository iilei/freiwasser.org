### Terraform Plan / Apply

```sh
    # Plan changes
sops exec-env ./infrastructure/secrets.sops.yaml 'terraform -chdir=infrastructure plan'

# Apply changes
sops exec-env ./infrastructure/secrets.sops.yaml 'terraform -chdir=infrastructure apply'

# Get server IP for DNS setup
terraform -chdir=infrastructure output server_ipv4_address
terraform -chdir=infrastructure output dns_setup_instructions
```

### DNS Setup (Namecheap)

After running `terraform apply`:

1. Get the server IP: `terraform -chdir=infrastructure output server_ipv4_address`
2. Go to Namecheap Dashboard → Domain List → Manage → Advanced DNS
3. Add A Record:
   - **Type**: A Record
   - **Host**: `api` (or your subdomain)
   - **Value**: `<server-ip-from-terraform>`
   - **TTL**: Automatic
4. Add AAAA Record (optional, for IPv6):
   - **Type**: AAAA Record
   - **Host**: `api`
   - **Value**: `<server-ipv6-from-terraform>`
   - **TTL**: Automatic
5. Wait 5-30 minutes for DNS propagation
6. Test: `dig api.yourdomain.com` 