# Grant cleaner service account access to delete references in Google Container Registry
resource "google_storage_bucket_access_control" "this" {
  for_each = {
    for item in toset(local.project_storage_region) : "${item.storage_region}${item.project_id}" => item
  }

  bucket = each.value.storage_region != "" ? "${each.value.storage_region}.artifacts.${each.value.project_id}.appspot.com" : "artifacts.${each.value.project_id}.appspot.com"
  role   = "WRITER"
  entity = "user-${google_service_account.cleaner.email}"
}

# Add IAM policy binding to the Cloud Run service
resource "google_cloud_run_service_iam_binding" "this" {
  location = google_cloud_run_service.this.location
  project  = google_cloud_run_service.this.project
  service  = google_cloud_run_service.this.name
  role     = "roles/run.invoker"
  members = [
    "serviceAccount:${google_service_account.invoker.email}"
  ]
}
