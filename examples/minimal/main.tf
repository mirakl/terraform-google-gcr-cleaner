module "gcr_cleaner" {
  source = "../.."

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
