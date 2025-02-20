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

resource "linode_volume" "mc_storage" {
  label  = "mc-storage"
  region = var.region
  size   = 20  # 20GB storage for MC
}

resource "kubernetes_storage_class" "mc_storage_class" {
  metadata {
    name = "mc-storage-class"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  parameters = {
    type = "pd-standard"
  }
}

resource "kubernetes_persistent_volume" "mc_pv" {
  metadata {
    name = "mc-pv"
  }

  spec {
    capacity = {
      storage = "20Gi"
    }
    access_modes = ["ReadWriteOnce"]

    persistent_volume_source {
      host_path {
        path = "/mnt/mc-storage"  # Path inside the Kubernetes node
      }
    }

    persistent_volume_reclaim_policy = "Retain"  # Ensures data is not lost if PVC is deleted

    storage_class_name = "mc-storage-class"
  }
}

resource "kubernetes_persistent_volume_claim" "mc_pvc" {
  metadata {
    name      = "mc-pvc"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "20Gi"
      }
    }

    storage_class_name = "mc-storage-class"
    volume_name        = kubernetes_persistent_volume.mc_pv.metadata[0].name  # Explicitly bind to PV
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}