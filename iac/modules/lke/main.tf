terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

resource "linode_lke_cluster" "this" {
  label       = var.cluster_label
  k8s_version = var.k8s_version
  region      = var.region
  
  pool {
    type  = var.node_type
    count = var.node_count
  }
}

resource "local_file" "kubeconfig" {
  # filename = "${path.module}/kubeconfig"
  content  = base64decode(linode_lke_cluster.this.kubeconfig)
  filename = "${path.module}/kubeconfig"
}

output "kubeconfig_path" {
  value = local_file.kubeconfig.filename
}