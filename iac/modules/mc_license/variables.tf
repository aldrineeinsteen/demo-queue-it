variable "namespace" {
  type        = string
  description = "The namespace where secret (for license) resources should be created"
}
variable "kubeconfig" {
  type        = string
  description = "Path to the Kubernetes kubeconfig file"
}