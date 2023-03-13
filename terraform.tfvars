project_id   = "gke-acm-379108"
network_name = "anthos-vpc"

subnets = [
  {
    subnet_name   = "subnet-01"
    subnet_ip     = "10.10.10.0/24"
    subnet_region = "europe-west6"
  },
  {
    subnet_name   = "subnet-02"
    subnet_ip     = "10.10.20.0/24"
    subnet_region = "europe-west6"

  },
  {
    subnet_name   = "subnet-03"
    subnet_ip     = "10.10.30.0/24"
    subnet_region = "europe-west6"
  },
]

secondary_ranges = {
  subnet-01 = [
    {
      range_name    = "subnet-01-secondary-pod"
      ip_cidr_range = "192.168.0.0/24"
    },
    {
      range_name    = "subnet-01-secondary-service"
      ip_cidr_range = "192.168.1.0/24"
    },
  ]

  subnet-02 = [
    {
      range_name    = "subnet-02-secondary-pod"
      ip_cidr_range = "192.168.2.0/24"
    },
    {
      range_name    = "subnet-02-secondary-service"
      ip_cidr_range = "192.168.3.0/24"
    },
  ]

  subnet-03 = [
    {
      range_name    = "subnet-03-secondary-pod"
      ip_cidr_range = "192.168.4.0/24"
    },
    {
      range_name    = "subnet-03-secondary-service"
      ip_cidr_range = "192.168.5.0/24"
    },
  ]
}

routes = [
  {
    name              = "egress-internet"
    description       = "route through IGW to access internet"
    destination_range = "0.0.0.0/0"
    tags              = "egress-inet"
    next_hop_internet = "true"
  },
]

names         = ["tf-compute-sa"]
project_roles = ["gke-acm-379108=>roles/editor"]
display_name  = "tf-compute-sa"
description   = "Compute Engine service account"

gke-name                   = "acm-gke"
region                     = "europe-west6"
zones                      = ["europe-west6-a", "europe-west6-b"]
subnetwork                 = "subnet-01"
ip_range_pods              = "subnet-01-secondary-pod"
ip_range_services          = "subnet-01-secondary-service"
http_load_balancing        = false
network_policy             = false
horizontal_pod_autoscaling = true
filestore_csi_driver       = false

node_pools = [
  {
    name               = "tf-node-pool"
    machine_type       = "e2-standard-2"
    node_locations     = "europe-west6-a"
    min_count          = 1
    max_count          = 1
    local_ssd_count    = 0
    spot               = false
    disk_size_gb       = 100
    disk_type          = "pd-standard"
    image_type         = "COS_CONTAINERD"
    enable_gcfs        = false
    enable_gvnic       = false
    auto_repair        = true
    auto_upgrade       = true
    service_account    = "tf-compute-sa@gke-acm-379108.iam.gserviceaccount.com"
    preemptible        = false
    initial_node_count = 1
  },
]

node_pools_oauth_scopes = {
  all = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

node_pools_metadata = {
  all = {}

  default-node-pool = {
    node-pool-metadata-custom-value = "tf-node-pool"
  }
}

node_pools_tags = {
  all = []

  default-node-pool = [
    "tf-node-pool",
  ]
}