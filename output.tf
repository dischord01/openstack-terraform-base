# Output Rancher Url to access login page
output "hpe_servers" {
  value = ["https://${openstack_networking_floatingip_v2.hpe_server_ip.address}"]
}
