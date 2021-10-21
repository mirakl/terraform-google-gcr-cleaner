# Create a service account which will be assigned to the Cloud Run service
resource "google_service_account" "cleaner" {
  project = local.google_project_id
  # The account_id has to respect this regex: "^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$"
  account_id   = "gcr-cleaner-sa-id"
  display_name = "GCR Cleaner Service Account"
  description  = "It will be assigned to the Cloud Run service"
}

# Create a service account with permission to invoke the Cloud Run service
resource "google_service_account" "invoker" {
  project = local.google_project_id
  # The account_id has to respect this regex: "^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$"
  account_id   = "gcr-cleaner-invoker-sa-id"
  display_name = "GCR Cleaner Invoker Service Account"
  description  = "It will invoke the Cloud Run service"
}
