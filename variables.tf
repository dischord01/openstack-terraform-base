variable "prefix" {
  type        = string
  description = "A prefix for created resources to avoid clashing names"
}

variable "count_worker_nodes" {
  type        = string
  description = "Number of worker nodes"
  default     = "2"
}

variable "count_master" {
  type        = string
  description = "Number of master nodes"
  default     = "1"
}

variable "hpe_worker_flavor" {
  type        = string
  description = "Worker nodes types, in term CPU, Memory and Bandwith"
  default     = "R1-Generic-8"
}

variable "hpe_master_flavor" {
  type        = string
  description = "Master nodes types, in term CPU, Memory and Bandwith"
  default     = "R1-Generic-8"
}

variable "hpe_server_flavor" {
  type        = string
  description = "hpe2 server node types, in term CPU, Memory and Bandwith"
  default     = "R1-Generic-8"
}

variable "hpe_node_image_id" {
  type        = string
  description = "Image ID which instances will created from. Ubuntu Image ID"
}

variable "external_network" {
  type        = string
  description = "Openstack External network name to connect nodes to outside world"
  default     = "Public_Network"

}

variable "subnet_cidr" {
  type        = string
  description = "Openstack subnet CIDR where instances IPs will be assigned"
  default     = "192.168.206.0/24"

}

variable "ip_pool_name" {
  type        = string
  description = "Openstack Floating IP allocation pool name"
  default     = "Public_Network"
}

variable "public_key" {
  type        = string
  description = "SSH Public key content to be imported and used into created instances"
}
