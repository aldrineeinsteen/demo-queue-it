output "namespace_name" {
  value = kubernetes_namespace.mc_system.metadata[0].name
  description = "Namespace for Mission Control"
}