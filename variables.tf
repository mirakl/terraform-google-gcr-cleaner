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
  description = "The location of the cloud run instance. Make sure to provide a valid location. More at https://cloud.google.com/run/docs/locations"
  type        = string
  default     = "europe-west1"
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
