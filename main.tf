# # Remote backend bucket

# resource "google_storage_bucket" "this" {
#   name          = "gke-acm-379108-anthos-platform-tf-state"
#   force_destroy = false
#   location      = "EU"
#   storage_class = "STANDARD"
#   versioning {
#     enabled = true
#   }
# }

# data source to access the configuration of the Google Cloud provider

data "google_client_config" "current" {}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 6.0"

  project_id       = var.project_id
  network_name     = var.network_name
  routing_mode     = var.routing_mode
  secondary_ranges = var.secondary_ranges
  subnets          = var.subnets
  routes           = var.routes
}

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  project_id    = var.project_id
  prefix        = var.prefix
  names         = var.names
  project_roles = var.project_roles
  display_name  = var.display_name
  description   = var.description
}

# Enable APIs for using Anthos with terraform 

module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  project_id                  = data.google_client_config.current.project
  disable_services_on_destroy = false
  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "anthos.googleapis.com",
    "cloudtrace.googleapis.com",
    "meshca.googleapis.com",
    "meshtelemetry.googleapis.com",
    "meshconfig.googleapis.com",
    "iamcredentials.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"
  ]
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = var.gke-name
  region                     = var.region
  zones                      = var.zones
  network                    = var.network_name
  subnetwork                 = var.subnetwork
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  http_load_balancing        = var.http_load_balancing
  network_policy             = var.network_policy
  horizontal_pod_autoscaling = var.horizontal_pod_autoscaling
  filestore_csi_driver       = var.filestore_csi_driver

  node_pools              = var.node_pools
  node_pools_oauth_scopes = var.node_pools_oauth_scopes
  node_pools_metadata     = var.node_pools_metadata
  node_pools_tags         = var.node_pools_tags

  depends_on = [
    module.vpc,
    module.service_accounts,
  ]
}

module "acm-operator" {
  source = "./module/acm"

  depends_on = [module.gke]
}

# resource "google_gke_hub_membership" "this" {
#   membership_id = "tf-acm-membership"
#   project       = var.project_id
#   endpoint {
#     gke_cluster {
#       resource_link = "//container.googleapis.com/${module.gke.cluster_id}"
#     }
#   }
#   provider = google-beta
# }

# resource "google_gke_hub_feature" "this" {
#   name     = "configmanagement"
#   project  = var.project_id
#   location = "global"

#   labels = {
#     ref = "tf-hub-feature"
#   }
#   provider = google-beta
# }

# resource "google_gke_hub_feature_membership" "this" {
#   location   = "global"
#   feature    = google_gke_hub_feature.this.name
#   membership = google_gke_hub_membership.this.membership_id
#   configmanagement {
#     version = "1.8.0"
#     config_sync {
#       git {
#         sync_repo   = "https://github.com/AndreiMatrosau/gke-acm-demo.git"
#         sync_branch = "main"
#         policy_dir  = "acm-gke-repo/overlays/environment-1/cluster-1"
#         secret_type = "none"
#       }
#     }
#   }
#   provider = google-beta
# }

