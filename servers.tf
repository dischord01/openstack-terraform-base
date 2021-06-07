# Allocating public Ip addresses for hpe server
resource "openstack_networking_floatingip_v2" "hpe_server_ip" {
  pool = var.ip_pool_name
}

# Allocating public Ip addresses for master nodes
resource "openstack_networking_floatingip_v2" "hpe_master_ips" {
  count = var.count_master
  pool  = var.ip_pool_name
}

# Allocating public Ip addresses for worker nodes
resource "openstack_networking_floatingip_v2" "hpe_workers_ips" {
  count = var.count_worker_nodes
  pool  = var.ip_pool_name
}

# Attaching Floating IPs to master nodes
resource "openstack_compute_floatingip_associate_v2" "hpe_master_ips_attach" {
  count       = var.count_master
  floating_ip = openstack_networking_floatingip_v2.hpe_master_ips[count.index].address
  instance_id = openstack_compute_instance_v2.hpe_master[count.index].id
  depends_on  = [openstack_compute_instance_v2.hpe_master]
}

# Attaching Floating IPs to worker nodes
resource "openstack_compute_floatingip_associate_v2" "hpe_workers_ips_attach" {
  count       = var.count_worker_nodes
  floating_ip = openstack_networking_floatingip_v2.hpe_workers_ips[count.index].address
  instance_id = openstack_compute_instance_v2.hpe_worker[count.index].id
  depends_on  = [openstack_compute_instance_v2.hpe_worker]
}

# Attaching Floating IP to hpe server
resource "openstack_compute_floatingip_associate_v2" "hpe_server_ip_attach" {
  floating_ip = openstack_networking_floatingip_v2.hpe_server_ip.address
  instance_id = openstack_compute_instance_v2.hpe_server[0].id
  depends_on  = [openstack_compute_instance_v2.hpe_server]
}


# Creating hpe Server instance
resource "openstack_compute_instance_v2" "hpe_server" {
  count           = "1"
  name            = "${var.prefix}-hpeserver"
  flavor_name     = var.hpe_server_flavor
  key_pair        = openstack_compute_keypair_v2.demo_keypair.name
  security_groups = [openstack_networking_secgroup_v2.demo_secgroup.name]
  user_data       = data.template_file.cloud-config-server.rendered

  # Booting from volumes, as some cloud-providers do not allow booting from image
  block_device {

    uuid                  = var.hpe_node_image_id
    source_type           = "image"
    volume_size           = 50
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = openstack_networking_network_v2.demo_network.name
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }

  depends_on = [openstack_compute_keypair_v2.demo_keypair, openstack_networking_subnet_v2.demo_subnet, openstack_networking_floatingip_v2.hpe_server_ip]
}

# Creating kubernetes master nodes
resource "openstack_compute_instance_v2" "hpe_master" {
  count           = var.count_master
  name            = "${var.prefix}-master-${count.index + 1}"
  flavor_name     = var.hpe_master_flavor
  key_pair        = openstack_compute_keypair_v2.demo_keypair.name
  security_groups = [openstack_networking_secgroup_v2.demo_secgroup.name]
  user_data       = data.template_file.cloud-config-master.rendered

  # Booting from volumes, as some cloud-providers do not allow booting from image
  block_device {

    uuid                  = var.hpe_node_image_id
    source_type           = "image"
    volume_size           = 50
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = openstack_networking_network_v2.demo_network.name
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }

  depends_on = [openstack_compute_keypair_v2.demo_keypair, openstack_networking_subnet_v2.demo_subnet, openstack_networking_floatingip_v2.hpe_master_ips]
}

# Creating kubernetes worker nodes
resource "openstack_compute_instance_v2" "hpe_worker" {
  count           = var.count_worker_nodes
  name            = "${var.prefix}-worker-${count.index + 1}"
  flavor_name     = var.hpe_worker_flavor
  key_pair        = openstack_compute_keypair_v2.demo_keypair.name
  security_groups = [openstack_networking_secgroup_v2.demo_secgroup.name]
  user_data       = data.template_file.cloud-config-worker.rendered

  # Booting from volumes, as some cloud-providers do not allow booting from image
  block_device {

    uuid                  = var.hpe_node_image_id
    source_type           = "image"
    volume_size           = 50
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = openstack_networking_network_v2.demo_network.name
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }

  depends_on = [openstack_compute_keypair_v2.demo_keypair, openstack_networking_subnet_v2.demo_subnet, openstack_networking_floatingip_v2.hpe_workers_ips]
}

