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

# Allow the account that is running terraform permissions to act-as
# the service-account, required for deploying a CloudRun service
resource "google_service_account_iam_member" "tf-cleaner" {
  count = local.running_as_a_service_account ? 1 : 0

  service_account_id = google_service_account.cleaner.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_client_openid_userinfo.terraform.email}"
}

# Allow the account that is running terraform permissions to act-as
# the service-account, required for deploying a CloudScheduler service
resource "google_service_account_iam_member" "tf-invoker" {
  count = local.running_as_a_service_account ? 1 : 0

  service_account_id = google_service_account.invoker.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_client_openid_userinfo.terraform.email}"
}