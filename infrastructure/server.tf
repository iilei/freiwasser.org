# Hetzner Cloud Server (imported existing server)
resource "hcloud_server" "main" {
  name        = "ubuntu-8gb-nbg1-2-velora"
  server_type = "cx33"  # 4 vCPU, 8GB RAM
  image       = "ubuntu-24.04"
  location    = "nbg1"  # Nuremberg
  
  # Default settings to match imported server
  allow_deprecated_images    = false
  ignore_remote_firewall_ids = false
  keep_disk                  = false
  shutdown_before_deletion   = false
  
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  # Ignore changes to attributes that were set during manual creation
  lifecycle {
    ignore_changes = [
      ssh_keys,
      user_data,
      labels
    ]
  }
}

# Optional: Reverse DNS (uncomment and update domain when ready)
# resource "hcloud_rdns" "main_ipv4" {
#   server_id  = hcloud_server.main.id
#   ip_address = hcloud_server.main.ipv4_address
#   dns_ptr    = "freudeambaden.de"
# }
#
# resource "hcloud_rdns" "main_ipv6" {
#   server_id  = hcloud_server.main.id
#   ip_address = hcloud_server.main.ipv6_address
#   dns_ptr    = "freudeambaden.de"
# }
