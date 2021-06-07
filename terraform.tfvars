# please fill these variables or use TF_VARS_ prefix to be exported env variables
# 
#openstack_username = ""
#openstack_password = "" 
#openstack_domain   = ""
#openstack_project  = ""
#openstack_auth_url = ""
#public_key         = ""



# Nodes server Image ID
hpe_node_image_id = ""

count_master = "1"

# Count of agent nodes with role worker
count_worker_nodes = "2"

# Resources will be prefixed with this to avoid clashing names
prefix = "hpe-demo"

# Name of floating IP pool
ip_pool_name = "external-floating-ips"
# ID of External Network
external_network = "external-floating-ips"

# Instances' flavor size
hpe_master_flavor = "t1.xlarge"
hpe_worker_flavor = "t1.xlarge"
hpe_server_flavor = "t1.xlarge"

# Admin password to access hpe
# hpe_admin_password = "admin123"

# Name of custom cluster that will be created
# cluster_name = "demo"

