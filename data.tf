# get project details
data "google_project" "this" {
  project_id = var.project_id
}

# get all repositories of a given project
data "external" "this" {
  for_each = {
    for repo in local.project_all_repositories : "${repo.google_project_id}/${repo.gcr_host_name}" => repo
  }

  program = ["${path.module}/scripts/get_all_repositories.sh"]
  query = {
    gcr_host_name     = each.value.gcr_host_name
    google_project_id = each.value.google_project_id
  }
}

data "google_storage_bucket" "bucket" {
  for_each = toset(local.buckets)

  name = each.value.storage_bucket
}

data "google_client_openid_userinfo" "terraform" {}