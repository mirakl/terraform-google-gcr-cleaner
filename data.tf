# get project details
data "google_project" "this" {}

# get all repositories of a given project/filter
data "external" "this" {
  for_each = local.project_all_repositories_map

  program = ["${path.module}/scripts/get_all_repositories.sh"]
  query = {
    gcr_host_name     = each.value.gcr_host_name
    google_project_id = each.value.google_project_id
  }
}
