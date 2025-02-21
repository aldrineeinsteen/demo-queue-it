variable "namespace" {
  type        = string
  description = "The namespace where storage resources should be created"
}
variable "kubeconfig" {
  type        = string
  description = "Path to the Kubernetes kubeconfig file"
}