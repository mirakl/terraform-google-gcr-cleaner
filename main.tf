# Deploy the gcr-cleaner container on Cloud Run
# running as gcr-cleaner service account
resource "google_cloud_run_service" "this" {
  name     = var.cloud_run_service_name
  location = var.cloud_run_service_location

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = var.cloud_run_service_maximum_instances
        "run.googleapis.com/client-name"   = "cloud-scheduler"
      }
    }

    spec {
      containers {
        image = var.gcr_cleaner_image
      }
      service_account_name = google_service_account.cleaner.email
      timeout_seconds      = var.cloud_run_service_timeout_seconds
    }
  }

  autogenerate_revision_name = true

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.this]
}

# Create a Cloud Scheduler HTTP job to invoke the function
# 1. App Engine app
#
# /!\ Terraform is not able to delete App Engine applications
# so if you have to destroy all resources then apply in same project,
# just import google_app_engine_application resource before applying:
# terraform import google_app_engine_application.this your-project-id
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_application
#
# /!\ If you want to create your app engine app using terraform, just set `create_app_engine_app` variable to true
# and provide the app engine app location:
# create_app_engine_app           = true
# app_engine_application_location = "us-central1"
resource "google_app_engine_application" "this" {
  count = var.create_app_engine_app ? 1 : 0

  project     = local.google_project_id
  location_id = var.app_engine_application_location

  depends_on = [google_project_service.this]
}

# 2. Cloud Scheduler job that triggers an action via HTTP
resource "google_cloud_scheduler_job" "this" {
  for_each = {
    # name must match the RE2 regular expression "[a-zA-Z\d_-]{1,500}"
    # and be no more than 500 characters.
    # First replace all special characters with '-',
    # then replace any at least 2 consecutive `-` characters with one '-'.
    for repo in toset(local.fetched_repositories) : replace(replace("${repo.filter}:${repo.repo}", "/[\\W+:/]/", "-"), "/-{2,}/", "-") => repo
  }

  name             = each.key
  description      = "Cleanup ${each.value.repo} using ${each.value.filter} filter"
  schedule         = var.cloud_scheduler_job_schedule
  time_zone        = var.cloud_scheduler_job_time_zone
  attempt_deadline = "${var.cloud_scheduler_job_attempt_deadline}s"
  region           = local.cloud_scheduler_job_location

  retry_config {
    retry_count          = var.cloud_scheduler_job_retry_count
    min_backoff_duration = "${var.cloud_scheduler_job_min_backoff_duration}s"
    max_backoff_duration = "${var.cloud_scheduler_job_max_backoff_duration}s"
    max_retry_duration   = "${var.cloud_scheduler_job_max_retry_duration}s"
    max_doublings        = var.cloud_scheduler_job_max_doublings
  }

  http_target {
    http_method = "POST"
    uri         = "${google_cloud_run_service.this.status[0].url}/http"
    body        = base64encode("{\"allow_tagged\":${each.value.allow_tagged}, \"grace\":\"${each.value.grace}\", \"keep\":${each.value.keep}, \"repos\":[\"${each.value.repo}\"], \"tag_filter\":\"${each.value.tag_filter}\", \"recursive\":${each.value.recursive}}")
    oidc_token {
      service_account_email = google_service_account.invoker.email
    }
  }

  depends_on = [google_project_service.this, google_app_engine_application.this]
}
