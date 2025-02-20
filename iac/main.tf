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
  node_count    = 3
}

output "kubeconfig" {
  value     = module.lke.kubeconfig
  sensitive = true
}

module "namespace" {
  source    = "./modules/namespace"
  namespace = "mc-system"
  kubeconfig = module.lke.kubeconfig
  lke_dependency = module.lke
}

module "storage" {
  source    = "./modules/storage"
  region    = "gb-lon"
  namespace = module.namespace.namespace_name
  kubeconfig = module.lke.kubeconfig
}

module "kots" {
  source     = "./modules/kots"
  kubeconfig = module.lke.kubeconfig
}

module "service_account" {
  source    = "./modules/service_account"
  namespace = module.namespace.namespace_name
  kubeconfig = module.lke.kubeconfig
}

module "license" {
  source    = "./modules/mc_license"
  namespace = module.namespace.namespace_name
  kubeconfig = module.lke.kubeconfig
}

module "mc" {
  source = "./modules/mission-control"
  namespace = module.namespace.namespace_name
  admin_password = "password"
  kubeconfig = module.lke.kubeconfig
}

provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}
