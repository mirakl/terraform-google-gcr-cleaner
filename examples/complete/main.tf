module "gcr_cleaner" {
  source = "../.."

  # If you want to create your App Engine Application using terraform, uncomment the following
  # create_app_engine_app = true

  app_engine_application_location          = "europe-west3"
  cloud_run_service_name                   = "gcr-cleaner-helsinki"
  cloud_run_service_location               = "europe-north1"
  cloud_run_service_maximum_instances      = 300
  cloud_run_service_timeout_seconds        = 300
  gcr_cleaner_image                        = "europe-docker.pkg.dev/gcr-cleaner/gcr-cleaner/gcr-cleaner"
  cloud_scheduler_job_schedule             = "0 2 * * 5"
  cloud_scheduler_job_time_zone            = "Europe/Helsinki"
  cloud_scheduler_job_attempt_deadline     = 600
  cloud_scheduler_job_retry_count          = 3
  cloud_scheduler_job_min_backoff_duration = 10
  cloud_scheduler_job_max_backoff_duration = 300
  cloud_scheduler_job_max_retry_duration   = 10
  cloud_scheduler_job_max_doublings        = 2
  gcr_repositories = [
    {
      storage_region = "eu"
      repositories = [
        {
          # in `test/nginx` repository, delete all images older than 30 days (720h)
          name  = "test/nginx"
          grace = "720h"
        },
        {
          # in `test/python` repository, keep 3 `alpha` tags
          name         = "test/python"
          allow_tagged = true
          keep         = 3
          tag_filter   = "^alpha.+$"
        },
        {
          # in `test/tools/ci` repository and all its child repositories, keep only 5 tags
          name         = "test/tools/ci"
          allow_tagged = true
          keep         = 5
          recursive    = true
        }
      ]
    },
    {
      # in all repositories, delete all untagged images
      clean_all      = true
      storage_region = "eu"
    },
    {
      # in all repositories, keep 5 `beta` tags, ignore anything newer than 5 days
      clean_all      = true
      storage_region = "eu"
      parameters = {
        allow_tagged = true
        keep         = 5
        grace        = "120h"
        tag_filter   = "^beta.+$"
      }
    },
    {
      # in all repositories, keep 10 `live` tags, ignore anything newer than 15 days
      clean_all      = true
      storage_region = "eu"
      parameters = {
        allow_tagged = true
        keep         = 10
        grace        = "360h"
        tag_filter   = "^live.+$"
      }
    }
  ]
}
