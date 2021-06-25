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
      for repo in gcr.repositories : gcr.storage_region != null
        ? merge(
            repo,
            {
              repo = "${gcr.storage_region}.gcr.io/${gcr.project_id != null ? gcr.project_id : local.google_project_id}/${repo.repo}",
              grace = repo.grace != null ? repo.grace : "0",
              allow_tagged = repo.allow_tagged != null ? repo.allow_tagged : false,
              tag_filter = repo.tag_filter != null ? repo.tag_filter : ""
            }
        )
        : merge(
            repo,
            {
              repo = "gcr.io/${gcr.project_id != null ? gcr.project_id : local.google_project_id}/${repo.repo}",
              grace = repo.grace != null ? repo.grace : "0",
              allow_tagged = repo.allow_tagged != null ? repo.allow_tagged : false,
              tag_filter = repo.tag_filter != null ? repo.tag_filter : ""
            }
        )
    ] if gcr.repositories != null
  ])

  # merge all fetched repositories with external data in one list
  fetched_repositories = flatten([
    for data in data.external.this : [
      for repo in jsondecode(data.result.repositories) : merge(
        local.options[repo.project_id],
        {
          "repo": repo.name
          grace = local.options[repo.project_id].grace != null ? local.options[repo.project_id].grace : "0",
          allow_tagged = local.options[repo.project_id].allow_tagged != null ? local.options[repo.project_id].allow_tagged : false,
          keep = local.options[repo.project_id].keep != null ? local.options[repo.project_id].keep : 0,
          tag_filter = local.options[repo.project_id].tag_filter != null ? local.options[repo.project_id].tag_filter : ""
        }
      )
    ]
  ])

  options = {
    for gcr in var.gcr_repositories : (gcr.project_id != null ? gcr.project_id : local.google_project_id) => gcr.parameters
  }
}
