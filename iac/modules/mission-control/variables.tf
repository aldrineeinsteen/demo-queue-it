variable "namespace" {
  type        = string
  description = "Namespace where Mission Control will be deployed"
}
variable "admin_password" {
  type        = string
  description = "Password for the admin user"  
}
variable "kubeconfig" {
  type        = string
  description = "Path to the Kubernetes kubeconfig file"
}