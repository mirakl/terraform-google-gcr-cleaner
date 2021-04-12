module "gcr_cleaner" {
  source = "../.."

  # If you want to create your App Engine Application using terraform, uncomment the following
  # create_app_engine_app = true

  app_engine_application_location      = "europe-west3"
  cloud_run_service_name               = "gcr-cleaner-helsinki"
  cloud_run_service_location           = "europe-north1"
  cloud_run_service_maximum_instances  = 300
  cloud_run_service_timeout_seconds    = 300
  gcr_cleaner_image                    = "europe-docker.pkg.dev/gcr-cleaner/gcr-cleaner/gcr-cleaner"
  cloud_scheduler_job_schedule         = "0 2 * * 5"
  cloud_scheduler_job_time_zone        = "Europe/Helsinki"
  cloud_scheduler_job_attempt_deadline = 600
  cloud_scheduler_job_retry_count      = 3
  gcr_repositories = [
    {
      storage_region = "eu"
      repositories = [
        "test/nginx",
      ]
    },
    {
      storage_region = "eu"
      project_id     = "yet-another-project-id"
      clean_all      = true
    },
    {
      project_id = "another-project-id"
      repositories = [
        "test/image",
      ]
    }
  ]
}
