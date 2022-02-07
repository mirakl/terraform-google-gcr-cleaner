# Enable the Google APIs
resource "google_project_service" "this" {
  for_each = {
    for api in local.google_apis : api => api
  }

  project                    = local.google_project_id
  service                    = each.value
  disable_dependent_services = var.disable_dependent_services
  disable_on_destroy         = var.disable_on_destroy
}
