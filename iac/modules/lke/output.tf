output "kubeconfig" {
  value     = linode_lke_cluster.this.kubeconfig
  sensitive = true
}