resource "kubernetes_stateful_set" "kotsadm_minio" {
  metadata {
    name      = "kotsadm-minio"
    namespace = var.namespace
  }

  spec {
    service_name = "kotsadm-minio"
    replicas     = 1

    selector {
      match_labels = {
        app = "kotsadm-minio"
      }
    }

    template {
      metadata {
        labels = {
          app = "kotsadm-minio"
        }
      }

      spec {
        security_context {
          run_as_user  = 1000
          run_as_group = 1000
          fs_group     = 1000
        }

        init_container {
          name  = "fix-permissions"
          image = "busybox"
          command = [
            "sh", "-c",
            "chown -R 1000:1000 /export && chmod -R u+rwX /export"
          ]
          volume_mount {
            name       = "minio-storage"
            mount_path = "/export"
          }
        }

        container {
          name  = "kotsadm-minio"
          image = "kotsadm/minio:latest"

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
          }

          volume_mount {
            name       = "minio-storage"
            mount_path = "/export"
          }
        }

        volume {
          name = "minio-storage"
          persistent_volume_claim {
            claim_name = "kotsadm-minio-kotsadm-minio-0"
          }
        }
      }
    }
  }
}

resource "kubernetes_stateful_set" "kotsadm_rqlite" {
  metadata {
    name      = "kotsadm-rqlite"
    namespace = var.namespace
  }

  spec {
    service_name = "kotsadm-rqlite"
    replicas     = 1

    selector {
      match_labels = {
        app = "kotsadm-rqlite"
      }
    }

    template {
      metadata {
        labels = {
          app = "kotsadm-rqlite"
        }
      }

      spec {
        security_context {
          run_as_user  = 1000
          run_as_group = 1000
          fs_group     = 1000
        }

        container {
          name  = "kotsadm-rqlite"
          image = "kotsadm/rqlite:latest"

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
          }

          args = [
            "-node-id", "kotsadm-rqlite-0",
            "-http-addr", "0.0.0.0:4001",
            "-http-adv-addr", "kotsadm-rqlite-0.kotsadm-rqlite-headless.${var.namespace}.svc.cluster.local:4001",
            "-raft-addr", "0.0.0.0:4002",
            "-raft-adv-addr", "kotsadm-rqlite-0.kotsadm-rqlite-headless.${var.namespace}.svc.cluster.local:4002",
            "-disco-mode", "dns",
            "-disco-config", "{\"name\":\"kotsadm-rqlite-headless.${var.namespace}.svc\"}",
            "-bootstrap-expect", "1"
          ]

          volume_mount {
            name       = "rqlite-storage"
            mount_path = "/rqlite/file"
          }
          volume_mount {
            name       = "rqlite-storage"
            mount_path = "/rqlite/file"
          }
        }

        volume {
          name = "rqlite-storage"
          persistent_volume_claim {
            claim_name = "kotsadm-rqlite-kotsadm-rqlite-0"
          }
        }
      }
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}