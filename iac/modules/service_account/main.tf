resource "kubernetes_service_account" "mc_service_account" {
  metadata {
    name      = "mc-service-account"
    namespace = var.namespace 
  }
}

resource "kubernetes_cluster_role" "mc_cluster_role" {
  metadata {
    name = "mc-cluster-role"
  }

  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "mc_cluster_role_binding" {
  metadata {
    name = "mc-cluster-role-binding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.mc_service_account.metadata[0].name
    namespace = var.namespace
  }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.mc_cluster_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}