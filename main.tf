# Deploy the gcr-cleaner container on Cloud Run
# running as gcr-cleaner service account
resource "google_cloud_run_service" "this" {
  name     = var.cloud_run_service_name
  location = var.cloud_run_service_location

  template {
    spec {
      containers {
        image = var.gcr_cleaner_image
      }
      service_account_name = google_service_account.cleaner.email
      timeout_seconds      = 60
    }
  }

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
    for repo in local.repositories : repo => repo
  }

  # name must match the RE2 regular expression "[a-zA-Z\d_-]{1,500}"
  # and be no more than 500 characters.
  name        = "gcr-cleaner_${replace(each.value, "/[.\\/]/", "_")}"
  description = "Cleanup ${each.value}"
  schedule    = var.cloud_scheduler_job_schedule
  time_zone   = var.cloud_scheduler_job_time_zone
  # Location must equal to the one of the App Engine app that is associated with this project
  region = var.app_engine_application_location

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = "${google_cloud_run_service.this.status[0].url}/http"
    # TODO implement all payload parameters
    # https://github.com/sethvargo/gcr-cleaner#payload--parameters
    body = base64encode(jsonencode(map("repo", each.value)))
    oidc_token {
      service_account_email = google_service_account.invoker.email
    }
  }

  depends_on = [google_project_service.this, google_app_engine_application.this]
}
