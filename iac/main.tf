module "lke" {
  source         = "./modules/lke"
  cluster_label  = "queueit-demo-cluster"
  k8s_version    = "1.32"
  region         = "gb-lon"
  node_type      = "g6-dedicated-16"
  node_count     = 1
}

output "kubeconfig" {
  value     = module.lke.kubeconfig
  sensitive = true
}