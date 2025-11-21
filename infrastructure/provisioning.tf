# Basic server provisioning setup
# This prepares the server for Docker and reverse proxy installation

# Note: Connection details for provisioners
# You'll need to ensure SSH key access is configured

# Placeholder for future provisioning
# Uncomment and configure when ready to deploy

# resource "null_resource" "server_provisioning" {
#   depends_on = [hcloud_firewall_attachment.osm_server]
#
#   connection {
#     type        = "ssh"
#     host        = hcloud_server.main.ipv4_address
#     user        = "root"
#     private_key = file("~/.ssh/id_rsa")
#   }
#
#   provisioner "remote-exec" {
#     inline = [
#       "apt-get update",
#       "apt-get install -y curl wget git",
#       "echo 'Server provisioned successfully'"
#     ]
#   }
#
#   triggers = {
#     server_id = hcloud_server.main.id
#   }
# }

# Future: Docker installation
# Future: Reverse proxy setup (nginx or traefik based on var.reverse_proxy)
# Future: SSL certificate setup with certbot or traefik
