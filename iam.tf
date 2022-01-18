# Grant cleaner service account access to delete references in Google Container Registry
# for old-style ACL buckets
resource "google_storage_bucket_access_control" "this" {
  for_each = toset(local.google_storage_bucket_access_control)

  bucket = each.value
  role   = "WRITER"
  entity = "user-${google_service_account.cleaner.email}"
}

# Grant cleaner service account access to delete references in Google Container Registry
# for buckets with uniform_bucket_level_access = true
resource "google_storage_bucket_iam_member" "this" {
  for_each = toset(local.google_storage_bucket_iam_member)

  bucket = each.value
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${google_service_account.cleaner.email}"
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

# Grant cleaner service account roles/browser role in order to query the registry.
# This is the most minimal permission.
resource "google_project_iam_member" "this" {
  project = google_cloud_run_service.this.project
  role    = "roles/browser"
  member  = "serviceAccount:${google_service_account.cleaner.email}"
}
