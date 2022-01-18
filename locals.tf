locals {
  # get project id (used by google provider)
  google_project_id = split("/", data.google_project.this.id)[1]

  google_apis = [
    "appengine.googleapis.com",
    "cloudscheduler.googleapis.com",
    "run.googleapis.com"
  ]

  # cloud_scheduler_job.location must equal to the one of the App Engine app that is associated with this project
  # /!\ Note that two locations, called europe-west and us-central in App Engine commands,
  # are called, respectively, europe-west1 and us-central1 in Cloud Scheduler commands.
  # More on https://cloud.google.com/appengine/docs/locations
  cloud_scheduler_job_location = contains(["europe-west", "us-central"], var.app_engine_application_location) == true ? "${var.app_engine_application_location}1" : var.app_engine_application_location

  # create a list of buckets from the gcr_repositories input
  buckets = [
    for repo in var.gcr_repositories : repo.storage_region != null ? "${repo.storage_region}.artifacts.${repo.project_id != null ? repo.project_id : local.google_project_id}.appspot.com" : "artifacts.${repo.project_id != null ? repo.project_id : local.google_project_id}.appspot.com"
  ]

  # Buckets having uniform_bucket_level_access = true
  google_storage_bucket_iam_member = [
    for bucket in local.buckets : bucket if data.google_storage_bucket.bucket[bucket].uniform_bucket_level_access
  ]

  # Buckets having uniform_bucket_level_access = false
  google_storage_bucket_access_control = [
    for bucket in local.buckets : bucket if !data.google_storage_bucket.bucket[bucket].uniform_bucket_level_access
  ]

  # create project_all_repositories list, appending storage_region and project_id when ommited
  # for projects having clean_all = true.
  # Set default values for optional fields.
  project_all_repositories = [
    for repo in var.gcr_repositories : {
      repo           = "${repo.storage_region != null ? "${repo.storage_region}.gcr.io" : "gcr.io"}/${repo.project_id != null ? repo.project_id : local.google_project_id}"
      grace          = repo.parameters != null ? (repo.parameters.grace != null ? repo.parameters.grace : "0") : "0"
      keep           = repo.parameters != null ? (repo.parameters.keep != null ? repo.parameters.keep : "0") : "0"
      tag_filter     = repo.parameters != null ? (repo.parameters.tag_filter != null ? repo.parameters.tag_filter : "") : ""
      tag_filter_any = repo.parameters != null ? (repo.parameters.tag_filter_any != null ? repo.parameters.tag_filter_any : "") : ""
      tag_filter_all = repo.parameters != null ? (repo.parameters.tag_filter_all != null ? repo.parameters.tag_filter_all : "") : ""
      recursive      = true
      filter         = repo.parameters != null ? "grace-${repo.parameters.grace != null ? repo.parameters.grace : "0"}-keep-${repo.parameters.keep != null ? repo.parameters.keep : "0"}-tag_filter-${repo.parameters.tag_filter != null ? repo.parameters.tag_filter : "no"}-tag_filter_any-${repo.parameters.tag_filter_any != null ? repo.parameters.tag_filter_any : "no"}-tag_filter_any-${repo.parameters.tag_filter_any != null ? repo.parameters.tag_filter_any : "no"}" : "delete-all-untagged-images-recursive"
    } if repo.clean_all == true
  ]

  # create repositories list for projects having explicit repositories definition.
  # Set default values for optional fields
  repositories = flatten([
    for gcr in var.gcr_repositories : [
      for repo in gcr.repositories : merge(repo,
        {
          repo           = "${gcr.storage_region != null ? "${gcr.storage_region}.gcr.io" : "gcr.io"}/${gcr.project_id != null ? gcr.project_id : local.google_project_id}/${repo.name}"
          grace          = repo.grace != null ? repo.grace : "0"
          keep           = repo.keep != null ? repo.keep : "0"
          tag_filter     = repo.tag_filter != null ? repo.tag_filter : ""
          tag_filter_any = repo.tag_filter_any != null ? repo.tag_filter_any : ""
          tag_filter_all = repo.tag_filter_all != null ? repo.tag_filter_all : ""
          recursive      = repo.recursive != null ? repo.recursive : false
          filter         = "grace-${repo.grace != null ? repo.grace : "0"}-keep-${repo.keep != null ? repo.keep : "0"}-tag_filter-${repo.tag_filter != null ? repo.tag_filter : "no"}-tag_filter_any-${repo.tag_filter_any != null ? repo.tag_filter_any : "no"}-tag_filter_all-${repo.tag_filter_all != null ? repo.tag_filter_all : "no"}-recursive-${repo.recursive != null ? repo.recursive : false}"
        }
      )
    ] if gcr.repositories != null
  ])

  # create final repositories list
  fetched_repositories = concat(local.project_all_repositories, local.repositories)
}
