terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
  }
}

resource "kubernetes_namespace" "mc_system" {
  metadata {
    name = var.namespace
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}