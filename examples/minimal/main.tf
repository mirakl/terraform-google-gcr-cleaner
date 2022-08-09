module "gcr_cleaner" {
  source = "../.."

  app_engine_application_location = "europe-west3"
  gcr_repositories = [
    {
      storage_region = "eu"
      repositories = [
        {
          # in `test/nginx` repository, delete all untagged images
          name = "test/nginx"
        },
        {
          # in `test/python` repository, delete all images older than 30 days (720h)
          name  = "test/python"
          grace = "720h"
        }
      ]
    }
  ]
  gar_repositories = [
    {
      name          = "foo/nginx"
      registry_name = "foo"
      region        = "europe-west1"
      project_id    = "foobar-123"
    },
    {
      name          = "foo/python"
      registry_name = "foo"
      region        = "europe-west1"
      project_id    = "foobar-123"
    }
  ]
}
