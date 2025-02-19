terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.34.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }
  }
}

provider "linode" {
  token = var.linode_token
}
module "lke" {
  source        = "./modules/lke"
  cluster_label = "queueit-demo-cluster"
  k8s_version   = "1.32"
  region        = "gb-lon"
  node_type     = "g6-dedicated-16"
  node_count    = 1
}

output "kubeconfig" {
  value     = module.lke.kubeconfig
  sensitive = true
}
provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}