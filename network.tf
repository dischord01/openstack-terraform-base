# Creating openstack network
resource "openstack_networking_network_v2" "demo_network" {
  name           = "hpe-demo"
  admin_state_up = "true"
}

# Creating openstack subnet with CIDR
resource "openstack_networking_subnet_v2" "demo_subnet" {
  name            = "hpe-demo"
  dns_nameservers = ["1.1.1.1", "1.0.0.1"] # Cloudflair DNS 
  network_id      = openstack_networking_network_v2.demo_network.id
  cidr            = var.subnet_cidr
  ip_version      = 4
  depends_on      = [openstack_networking_network_v2.demo_network]
}

# Creating openstack router
resource "openstack_networking_router_v2" "demo_router" {
  name                = "hpe-demo"
  external_network_id = data.openstack_networking_network_v2.external_network.id
}

# Creating router interface and attaching subnet to the router to make it reach the outside networks
resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.demo_router.id
  subnet_id = openstack_networking_subnet_v2.demo_subnet.id
}
