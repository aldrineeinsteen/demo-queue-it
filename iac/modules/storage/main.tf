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

resource "linode_volume" "minio_storage" {
  label  = "minio-storage"
  region = var.region
  size   = 10  # 10GB storage for MinIO
}

resource "linode_volume" "rqlite_storage" {
  label  = "rqlite-storage"
  region = var.region
  size   = 10  # 10GB storage for RQLite (see below in pv section to understand why it's 10GB)
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

resource "kubernetes_persistent_volume" "minio_pv" {
  metadata {
    name = "minio-pv"
  }

  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]

    persistent_volume_source {
      host_path {
        path = "/mnt/minio-storage"
      }
    }

    persistent_volume_reclaim_policy = "Retain"

    storage_class_name = "mc-storage-class"
  }
}

resource "kubernetes_persistent_volume" "rqlite_pv" {
  metadata {
    name = "rqlite-pv"
  }

  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]

    persistent_volume_source {
      host_path {
        path = "/mnt/rqlite-storage"
      }
    }

    persistent_volume_reclaim_policy = "Retain"

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

resource "kubernetes_persistent_volume_claim" "minio_pvc" {
  metadata {
    name      = "kotsadm-minio-kotsadm-minio-0"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }

    storage_class_name = "mc-storage-class"
    volume_name        = kubernetes_persistent_volume.minio_pv.metadata[0].name
  }
}

resource "kubernetes_persistent_volume_claim" "rqlite_pvc" {
  metadata {
    name      = "kotsadm-rqlite-kotsadm-rqlite-0"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi" # Increased from 5Gi to 10Gi to accomodate the following
        # │ Error: Failed to Create a Volume
        # │ 
        # │   with module.storage.linode_volume.rqlite_storage,
        # │   on modules/storage/main.tf line 24, in resource "linode_volume" "rqlite_storage":
        # │   24: resource "linode_volume" "rqlite_storage" {
        # │ 
        # │ [400] [size] Must be 10-16384
        # ╵
      }
    }

    storage_class_name = "mc-storage-class"
    volume_name        = kubernetes_persistent_volume.rqlite_pv.metadata[0].name
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}