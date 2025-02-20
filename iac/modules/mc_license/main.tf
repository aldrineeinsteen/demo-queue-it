resource "kubernetes_secret" "mc_license" {
  metadata {
    name      = "mc-license"
    namespace = var.namespace
  }

  data = {
    "license.yaml" = file("${path.root}/license/mc_license.yaml")
  }

  type = "Opaque"
}


provider "kubernetes" {
  config_path = var.kubeconfig
}