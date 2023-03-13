variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "network_name" {
  description = "The name of the network being created"
  type        = string
}

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC"
  default     = []
}

variable "prefix" {
  type        = string
  description = "Prefix applied to service account names."
  default     = ""
}

variable "names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

variable "project_roles" {
  type        = list(string)
  description = "Common roles to apply to all service accounts, project=>role as elements."
  default     = []
}

variable "display_name" {
  type        = string
  description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
  default     = "Terraform-managed service account"
}

variable "description" {
  type        = string
  description = "Default description of the created service accounts (defaults to no description)"
  default     = ""
}

variable "gke-name" {
  type        = string
  description = "The name of the cluster (required)"
}

variable "regional" {
  type        = bool
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  default     = false
}

variable "region" {
  type        = string
  description = "The region to host the cluster in (optional if zonal cluster / required if regional)"
  default     = null
}

variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = []
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to host the cluster in (required)"
}

variable "ip_range_pods" {
  type        = string
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "ip_range_services" {
  type        = string
  description = "The _name_ of the secondary subnet range to use for services"
}

variable "http_load_balancing" {
  type        = bool
  description = "Enable httpload balancer addon"
  default     = true
}

variable "network_policy" {
  type        = bool
  description = "Enable network policy addon"
  default     = false
}

variable "horizontal_pod_autoscaling" {
  type        = bool
  description = "Enable horizontal pod autoscaling addon"
  default     = true
}

variable "filestore_csi_driver" {
  type        = bool
  description = "The status of the Filestore CSI driver addon, which allows the usage of filestore instance as volumes"
  default     = false
}

variable "node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-node-pool"
    },
  ]
}

variable "node_pools_oauth_scopes" {
  type        = map(list(string))
  description = "Map of lists containing node oauth scopes by node-pool name"

  # Default is being set in variables_defaults.tf
  default = {
    all               = ["https://www.googleapis.com/auth/cloud-platform"]
    default-node-pool = []
  }
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name"

  # Default is being set in variables_defaults.tf
  default = {
    all               = {}
    default-node-pool = {}
  }
}

variable "node_pools_metadata" {
  type        = map(map(string))
  description = "Map of maps containing node metadata by node-pool name"

  # Default is being set in variables_defaults.tf
  default = {
    all               = {}
    default-node-pool = {}
  }
}

variable "node_pools_tags" {
  type        = map(list(string))
  description = "Map of lists containing node network tags by node-pool name"

  # Default is being set in variables_defaults.tf
  default = {
    all               = []
    default-node-pool = []
  }
}