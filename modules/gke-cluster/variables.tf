# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ------------------------------------------------------------------------------

variable "project_id" {
  description = "Project where resources will be created"
}

variable "serviceaccount_key" {
  description = "Service account key for the project"
}

# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ------------------------------------------------------------------------------

variable "cluster_name" {
  default = "k8s-cluster"
}

variable "network_name" {
  default = "network"
}

variable "main_compute_zone" {
  default = "europe-north1-a"
}

variable "additional_zones" {
  default = []
}

variable "enable_kubernetes_alpha" {
  default = "false"
}

variable "oauth_scopes" {
  type = "list"

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

variable "node_type" {
  default = "n1-standard-2"
}

variable "node_image_type" {
  default = "COS"
}

variable "initial_node_count" {
  default = 2
}

variable "kubernetes_version" {
  default = "1.10.5-gke.0"
}

variable "monitoring_service" {
  default = "monitoring.googleapis.com"
}

variable "logging_service" {
  default = "logging.googleapis.com"
}

variable "dashboard_disabled" {
  default     = false
  description = "Disable Kubernetes Dashboard"
}

variable "master_auth_username" {
  default     = ""
  description = "The username to use for HTTP basic authentication (setting both password and username to empty strings disables legacy basic authentication)"
}

variable "master_auth_password" {
  default     = ""
  description = "The password to use for HTTP basic authentication (setting both password and username to empty strings disables legacy basic authentication)"
}

variable "issue_client_certificate" {
  default     = true
  description = "Whether client certificate authorization is enabled"
}

variable "create_timeout" {
  default = "30m"
}

variable "update_timeout" {
  default = "10m"
}

variable "delete_timeout" {
  default = "10m"
}

variable "prevent_destroy_cluster" {
  default = false
}
