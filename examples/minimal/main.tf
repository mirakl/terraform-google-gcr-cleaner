module "gcr_cleaner" {
  source = "../.."

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
