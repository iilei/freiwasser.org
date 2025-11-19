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

# Instructions for manual DNS setup
output "dns_setup_instructions" {
  description = "Instructions for setting up DNS in Namecheap"
  value = <<-EOT
    
    To configure DNS in Namecheap:
    
    1. Go to Namecheap Dashboard → Domain List → Manage → Advanced DNS
    2. Add the following records:
    
       For ROOT DOMAIN (yourdomain.com):
       Type: A Record
       Host: @ 
       Value: ${hcloud_server.main.ipv4_address}
       TTL: 300 (5 minutes) or Automatic
       
       Type: AAAA Record
       Host: @
       Value: ${hcloud_server.main.ipv6_address}
       TTL: 300 (5 minutes) or Automatic
    
       For SUBDOMAIN (api.yourdomain.com):
       Type: A Record
       Host: api
       Value: ${hcloud_server.main.ipv4_address}
       TTL: 300 (5 minutes) or Automatic
       
       Type: AAAA Record
       Host: api
       Value: ${hcloud_server.main.ipv6_address}
       TTL: 300 (5 minutes) or Automatic
    
    3. Wait for DNS propagation (usually 5-30 minutes)
    4. Test with: dig yourdomain.com (or dig api.yourdomain.com)
  EOT
}
