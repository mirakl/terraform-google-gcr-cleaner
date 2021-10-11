# Grant cleaner service account access to delete references in Google Container Registry
# for old-style ACL buckets
resource "google_storage_bucket_access_control" "this" {
  for_each = toset(local.google_storage_bucket_access_control)

  bucket = each.value
  role   = "WRITER"
  entity = "user-${google_service_account.cleaner.email}"
}

# Grant cleaner service account access to delete references in Google Container Registry
# for buckets with uniform_bucket_level_access
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

# Allow the account that is running terraform permissions to act-as
# the service-account, required for deploying a CloudRun service
resource "google_service_account_iam_member" "tf-cleaner" {
  service_account_id = google_service_account.cleaner.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_client_openid_userinfo.terraform.email}"
}

# Allow the account that is running terraform permissions to act-as
# the service-account, required for deploying a CloudScheduler service
resource "google_service_account_iam_member" "tf-invoker" {
  service_account_id = google_service_account.invoker.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_client_openid_userinfo.terraform.email}"
}
