# Output server IP addresses for DNS configuration
output "server_ipv4_address" {
  description = "Public IPv4 address of the server - use this for your A record"
  value       = hcloud_server.main.ipv4_address
}

output "server_ipv6_address" {
  description = "Public IPv6 address of the server - use this for your AAAA record"
  value       = hcloud_server.main.ipv6_address
}

output "server_name" {
  description = "Name of the server"
  value       = hcloud_server.main.name
}

output "server_status" {
  description = "Status of the server"
  value       = hcloud_server.main.status
}

# Domain and subdomain configuration
output "domain" {
  description = "Base domain"
  value       = var.domain
}

output "subdomains" {
  description = "Configured subdomains"
  value       = [for subdomain in var.subdomains : "${subdomain}.${var.domain}"]
}

output "reverse_proxy" {
  description = "Configured reverse proxy"
  value       = var.reverse_proxy
}

# Instructions for manual DNS setup
output "dns_setup_instructions" {
  description = "Instructions for setting up DNS in Namecheap"
  value = <<-EOT

    To configure DNS in Namecheap for ${var.domain}:

    1. Go to Namecheap Dashboard → Domain List → Manage → Advanced DNS
    2. Add the following records:

       ROOT DOMAIN (@):
       Type: A Record, Host: @, Value: ${hcloud_server.main.ipv4_address}
       Type: AAAA Record, Host: @, Value: ${hcloud_server.main.ipv6_address}

       ${join("\n       ", [for subdomain in var.subdomains :
         "SUBDOMAIN (${subdomain}):\n       Type: A Record, Host: ${subdomain}, Value: ${hcloud_server.main.ipv4_address}\n       Type: AAAA Record, Host: ${subdomain}, Value: ${hcloud_server.main.ipv6_address}"])}

    3. TTL: 300 (5 minutes) or Automatic
    4. Wait for DNS propagation (usually 5-30 minutes)
    5. Test with: dig ${var.domain} or dig api.${var.domain}

    Configured subdomains:
    ${join("\n    ", [for subdomain in var.subdomains : "- ${subdomain}.${var.domain}"])}
  EOT
}
