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

  # create project_all_repositories list, appending storage_region and project_id when ommited
  # for projects having clean_all = true.
  # Set default values for optional fields.
  project_all_repositories = [
    for repo in var.gcr_repositories : {
      gcr_host_name     = "${repo.storage_region != null ? "${repo.storage_region}.gcr.io" : "gcr.io"}"
      google_project_id = "${repo.project_id != null ? repo.project_id : local.google_project_id}"
      repo              = "${repo.storage_region != null ? "${repo.storage_region}.gcr.io" : "gcr.io"}/${repo.project_id != null ? repo.project_id : local.google_project_id}"
      grace             = repo.parameters != null ? (repo.parameters.grace != null ? repo.parameters.grace : "0") : "0"
      allow_tagged      = repo.parameters != null ? (repo.parameters.allow_tagged != null ? repo.parameters.allow_tagged : false) : false
      keep              = repo.parameters != null ? (repo.parameters.keep != null ? repo.parameters.keep : "0") : "0"
      tag_filter        = repo.parameters != null ? (repo.parameters.tag_filter != null ? repo.parameters.tag_filter : "") : ""
      filter            = repo.parameters != null ? "grace-${repo.parameters.grace != null ? repo.parameters.grace : "0"}-allow_tagged-${repo.parameters.allow_tagged != null ? repo.parameters.allow_tagged : false}-keep-${repo.parameters.keep != null ? repo.parameters.keep : "0"}-tag_filter-${repo.parameters.tag_filter != null ? repo.parameters.tag_filter : "no"}" : "delete-all-untagged-images"
    } if repo.clean_all == true
  ]

  # create project_all_repositories_map, adding unique id for each item
  # in order to save parameters that will be merged later with data retrieved
  # from data.external
  project_all_repositories_map = {
    for item in local.project_all_repositories : "${item.repo}-${item.filter}" => item
  }

  # merge all fetched repositories using data.external in one list
  fetched_repositories_from_external_data = flatten([
    for key, element in data.external.this : [
      for item in jsondecode(element.result.repositories) : merge(
        local.project_all_repositories_map[key],
        {
          repo = item
        }
      )
    ]
  ])

  # create repositories list for projects having explicit repositories definition.
  # Set default values for optional fields
  repositories = flatten([
    for gcr in var.gcr_repositories : [
      for repo in gcr.repositories : merge(repo,
        {
          repo         = "${gcr.storage_region != null ? "${gcr.storage_region}.gcr.io" : "gcr.io"}/${gcr.project_id != null ? gcr.project_id : local.google_project_id}/${repo.name}"
          grace        = repo.grace != null ? repo.grace : "0"
          allow_tagged = repo.allow_tagged != null ? repo.allow_tagged : false
          keep         = repo.keep != null ? repo.keep : "0"
          tag_filter   = repo.tag_filter != null ? repo.tag_filter : ""
          filter       = "grace-${repo.grace != null ? repo.grace : "0"}-allow_tagged-${repo.allow_tagged != null ? repo.allow_tagged : false}-keep-${repo.keep != null ? repo.keep : "0"}-tag_filter-${repo.tag_filter != null ? repo.tag_filter : "no"}"
        }
      )
    ] if gcr.repositories != null
  ])

  # create final repositories list
  fetched_repositories = concat(local.fetched_repositories_from_external_data, local.repositories)

  # group repositories by project
  repositories_by_project = {
    for repo in var.gcr_repositories : repo.project_id != null ? repo.project_id : local.google_project_id => repo...
  }

  # create a list of tuple { project_id, storage_region } from repositories_by_project
  # that will be used in `iam.tf`
  project_storage_region = flatten([
    for key, repos in local.repositories_by_project : [
      for repo in repos : {
        project_id     = key
        storage_region = repo.storage_region != null ? repo.storage_region : ""
      }
    ]
  ])
}
