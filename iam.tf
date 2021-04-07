# Grant cleaner service account access to delete references in Google Container Registry
resource "google_storage_bucket_access_control" "this" {
  for_each = {
    for repo in var.gcr_repositories : repo.project_id != null ? repo.project_id : local.google_project_id => repo
  }
  bucket = each.value.storage_region != null ? "${each.value.storage_region}.artifacts.${each.value.project_id != null ? each.value.project_id : local.google_project_id}.appspot.com" : "artifacts.${each.value.project_id != null ? each.value.project_id : local.google_project_id}.appspot.com"
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
