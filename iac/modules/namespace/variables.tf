variable "namespace" {
  type        = string
  description = "Namespace where storage resources will be created"
}
variable "kubeconfig" {
  type        = string
  description = "Path to the Kubernetes kubeconfig file"
}
variable "lke_dependency" {
  type    = any
  default = null
}