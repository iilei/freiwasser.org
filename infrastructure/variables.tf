# Variable definitions for Hetzner Cloud infrastructure
# see sops:
# ➜  schwimmplatzkarte git:(master) ✗ sops decrypt  ./infrastructure/secrets.sops.yaml  | yq '. | keys'
# - TF_VAR_HCLOUD_API_KEY
# - TF_VAR_SSH__SSH_ID_ED25519_HCLOUD_FREIWASSER_ORG_SECRET_SECRET
# - TF_VAR_SSH__SSH_ID_ED25519_HCLOUD_FREIWASSER_ORG_PUB
# - TF_VAR_SSH__SSH_ID_ED25519_HCLOUD_FREIWASSER_ORG_SECRET_KEY


variable "HCLOUD_API_KEY" {
  description = "Hetzner Cloud API Key"
  type        = string
  sensitive   = true
}

variable "SSH__SSH_ID_ED25519_HCLOUD_FREIWASSER_ORG_SECRET_SECRET" {
  description = "SSH secret key secret"
  type        = string
  sensitive   = true
}

variable "SSH__SSH_ID_ED25519_HCLOUD_FREIWASSER_ORG_PUB" {
  description = "SSH public key"
  type        = string
  sensitive   = true
}

variable "SSH__SSH_ID_ED25519_HCLOUD_FREIWASSER_ORG_SECRET_KEY" {
  description = "SSH private key"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Base domain for the application"
  type        = string
  default     = "freiwasser.org"
}

variable "subdomains" {
  description = "List of subdomains to configure"
  type        = list(string)
  default     = ["api", "auth", "tiles", "db"]
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key for server access"
  type        = string
  default     = "~/.ssh/id_ed25519_hetzner_20251121.pub"
}

variable "reverse_proxy" {
  description = "Reverse proxy to use (nginx or traefik)"
  type        = string
  default     = "nginx"
  validation {
    condition     = contains(["nginx", "traefik"], var.reverse_proxy)
    error_message = "reverse_proxy must be either 'nginx' or 'traefik'"
  }
}
