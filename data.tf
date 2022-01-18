# get project details
data "google_project" "this" {}

data "google_storage_bucket" "bucket" {
  for_each = toset(local.buckets)

  name = each.value
}
