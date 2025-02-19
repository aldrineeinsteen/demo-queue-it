variable "cluster_label" {
  type        = string
  description = "Name of the Kubernetes cluster"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes version to deploy"
}

variable "region" {
  type        = string
  description = "Linode data center region"
}

variable "node_type" {
  type        = string
  description = "Instance type for nodes"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the cluster"
}