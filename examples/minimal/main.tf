module "gcr_cleaner" {
  source = "../.."

  google_project_id               = var.google_project_id
  create_app_engine_app           = false
  app_engine_application_location = "europe-west3"
  gcr_repositories = [
    {
      storage_region = "eu"
      repositories = [
        "test/nginx",
      ]
    }
  ]
}
