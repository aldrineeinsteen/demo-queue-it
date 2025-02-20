variable "namespace" {
  type        = string
  description = "Namespace for Mission Control service account"
}
variable "kubeconfig" {
  type        = string
  description = "Path to the Kubernetes kubeconfig file"
}