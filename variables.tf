variable "disable_dependent_services" {
  description = "If `true`, services that are enabled and which depend on this service should also be disabled when this service is destroyed. If `false` or unset, an error will be generated if any enabled services depend on this service when destroying it."
  type        = bool
  default     = false
}

variable "disable_on_destroy" {
  description = "If `true`, disable the service when the terraform resource is destroyed. May be useful in the event that a project is long-lived but the infrastructure running in that project changes frequently."
  type        = bool
  default     = false
}

variable "cloud_run_service_name" {
  description = "The name of the cloud run service."
  type        = string
  default     = "gcr-cleaner"
}

variable "cloud_run_service_location" {
  description = "The location of the cloud run instance. Make sure to provide a valid location. More at https://cloud.google.com/run/docs/locations."
  type        = string
  default     = "europe-west1"
}

variable "cloud_run_service_maximum_instances" {
  description = "The number of maximum instances to set for this revision. This value will be used in the `autoscaling.knative.dev/maxScale` annotation key."
  type        = number
  default     = 100
}

variable "cloud_run_service_timeout_seconds" {
  description = "TimeoutSeconds holds the max duration the instance is allowed for responding to a request."
  type        = number
  default     = 60
}

variable "create_app_engine_app" {
  description = "Whether to create an App Engine application."
  type        = bool
  default     = false
}

variable "app_engine_application_location" {
  description = "The location to serve the app from."
  type        = string
  default     = "europe-west1"
}

variable "gcr_cleaner_image" {
  description = "The docker image of the gcr cleaner to deploy to Cloud Run."
  type        = string
  default     = "gcr.io/gcr-cleaner/gcr-cleaner"
  validation {
    condition     = can(regex("^((asia|europe|us)-docker\\.pkg\\.dev\\/gcr-cleaner\\/gcr-cleaner\\/gcr-cleaner|gcr\\.io\\/gcr-cleaner\\/gcr-cleaner)$", var.gcr_cleaner_image))
    error_message = "The gcr cleaner image must be one of `gcr.io/gcr-cleaner/gcr-cleaner`, `asia-docker.pkg.dev/gcr-cleaner/gcr-cleaner/gcr-cleaner`, `europe-docker.pkg.dev/gcr-cleaner/gcr-cleaner/gcr-cleaner`, or `us-docker.pkg.dev/gcr-cleaner/gcr-cleaner/gcr-cleaner`."
  }
}

variable "gcr_repositories" {
  description = "List of Google Container Registries objects."
  type = list(object({
    # google project id, if ommited, it will be assigned `google_project_id` variable value
    project_id = optional(string)
    # location of the storage bucket
    storage_region = optional(string)
    # docker image repositories to clean
    repositories = optional(list(string))
    # or clean all project's repositories
    clean_all = optional(bool)
  }))
  default = []
  validation {
    condition = length(var.gcr_repositories) > 0 ? length([
      for repo in var.gcr_repositories : repo
      if(lookup(repo, "repositories", null) != null && lookup(repo, "clean_all", null) != null) ||
      (lookup(repo, "repositories", null) == null && lookup(repo, "clean_all", null) == null)
    ]) == 0 : true
    error_message = "One of the repositories in the list doesn't match the requirements. You have to provide repositories or clean_all, not both at the same time or none of them."
  }
}

variable "cloud_scheduler_job_schedule" {
  description = "Describes the schedule on which the job will be executed."
  type        = string
  # At 04:00 on Monday
  default = "0 4 * * 1"
}

variable "cloud_scheduler_job_time_zone" {
  description = "Specifies the time zone to be used in interpreting schedule. The value of this field must be a time zone name from the tz database. More on https://en.wikipedia.org/wiki/List_of_tz_database_time_zones"
  type        = string
  default     = "Europe/Brussels"
}

variable "cloud_scheduler_job_attempt_deadline" {
  description = "The deadline for job attempts in seconds. If the request handler does not respond by this deadline then the request is cancelled and the attempt is marked as a `DEADLINE_EXCEEDED` failure. The failed attempt can be viewed in execution logs. Cloud Scheduler will retry the job according to the `RetryConfig`. Value must be between 15 seconds and 24 hours"
  type        = number
  default     = 320
  validation {
    condition     = var.cloud_scheduler_job_attempt_deadline >= 15 && var.cloud_scheduler_job_attempt_deadline <= 86400
    error_message = "Value must be between 15 seconds and 24 hours."
  }
}

variable "cloud_scheduler_job_retry_count" {
  description = "The number of attempts that the system will make to run a job using the exponential backoff procedure described by maxDoublings. Values greater than 5 and negative values are not allowed."
  type        = number
  default     = 1
}

variable "cloud_scheduler_job_min_backoff_duration" {
  description = "The minimum amount of time to wait before retrying a job after it fails. A duration in seconds with up to nine fractional digits."
  type        = number
  default     = 5
}

variable "cloud_scheduler_job_max_backoff_duration" {
  description = "The maximum amount of time to wait before retrying a job after it fails. A duration in seconds with up to nine fractional digits."
  type        = number
  default     = 3600
}

variable "cloud_scheduler_job_max_retry_duration" {
  description = "The time limit for retrying a failed job, measured from time when an execution was first attempted. If specified with retryCount, the job will be retried until both limits are reached. A duration in seconds with up to nine fractional digits."
  type        = number
  default     = 0
}

variable "cloud_scheduler_job_max_doublings" {
  description = "The time between retries will double maxDoublings times. A job's retry interval starts at minBackoffDuration, then doubles maxDoublings times, then increases linearly, and finally retries retries at intervals of maxBackoffDuration up to retryCount times."
  type        = number
  default     = 5
}

variable "project_id" {
  type        = string
  description = "The project in which to deploy resources."
  default     = ""
}