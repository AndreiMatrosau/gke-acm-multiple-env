terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.55.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "< 5.0, >= 3.45"
    }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "2.9.0"
    # }
  }
}

provider "google" {
  #   version = "3.5.0"
  project = "gke-acm-379108"
  region  = "europe-west6"
  zone    = "europe-west6-a"
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}