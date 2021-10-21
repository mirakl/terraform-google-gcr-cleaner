locals {
  # get project id (used by google provider)
  google_project_id = split("/", data.google_project.this.id)[1]

  google_apis = [
    "appengine.googleapis.com",
    "cloudscheduler.googleapis.com",
    "run.googleapis.com"
  ]

  # create project_all_repositories list, appending storage_region and project_id when ommited
  # for projects having clean_all = true
  project_all_repositories = [
    for repo in var.gcr_repositories : {
      gcr_host_name     = repo.storage_region != null ? "${repo.storage_region}.gcr.io" : "gcr.io"
      google_project_id = repo.project_id != null ? repo.project_id : local.google_project_id
    } if repo.clean_all == true
  ]

  # create repositories list
  # for projects having explicit repositories definition
  repositories = flatten([
    for gcr in var.gcr_repositories : [
      for repo in gcr.repositories : gcr.storage_region != null ? "${gcr.storage_region}.gcr.io/${gcr.project_id != null ? gcr.project_id : local.google_project_id}/${repo}" : "gcr.io/${gcr.project_id != null ? gcr.project_id : local.google_project_id}/${repo}"
    ] if gcr.repositories != null
  ])

  # merge all fetched repositories with external data in one list
  fetched_repositories = flatten([
    for data in data.external.this : [
      for repo in jsondecode(data.result.repositories) : repo
    ]
  ])

  running_as_a_service_account = length(regexall(".*@.*[.]gserviceaccount[.]com", data.google_client_openid_userinfo.terraform.email)) > 0
}
