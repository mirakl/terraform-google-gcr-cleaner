# get project details
data "google_project" "this" {}

data "google_storage_bucket" "bucket" {
  for_each = toset(local.buckets)

  name = each.value
}

# Get OpenID userinfo about the credentials used with the Google provider, specifically the email of the user applying the terrafom plan
data "google_client_openid_userinfo" "terraform" {}
