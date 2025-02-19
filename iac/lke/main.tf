resource "linode_lke" "this" {
  label       = var.cluster_label
  k8s_version = var.k8s_version
  region      = var.region
  
  pool {
    type  = var.node_type
    count = var.node_count
  }
}

output "kubeconfig" {
  value     = linode_lke.this.kubeconfig
  sensitive = true
}