output "kubeconfig" {
  # value     = linode_lke_cluster.this.kubeconfig
  # value = local_file.kubeconfig.filename
  # sensitive = true
  value = abspath(local_file.kubeconfig.filename)
}