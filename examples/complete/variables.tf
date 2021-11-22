variable "google_project_id" {
  description = "The project ID to create resources under."
  type        = string
  default     = "project-terraform-test-dcbe3d0"
}

variable "region" {
  description = "The region where resources will be created."
  type        = string
  default     = "europe-west3"
}
