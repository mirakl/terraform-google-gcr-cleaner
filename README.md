# terraform-google-gcr-cleaner

Terraform module that implements [gcr-cleaner](https://github.com/sethvargo/gcr-cleaner), a tool that deletes untagged images in [Google Cloud Container Registry](https://cloud.google.com/container-registry)
and [Google Cloud Artifact Registry](https://cloud.google.com/artifact-registry).

## Prerequisites

Please install:

- [gcloud](https://cloud.google.com/sdk/gcloud/)

## Usage

- From current project (the provider's project)
  - in `test/nginx` repository, delete all untagged images
  - in `test/python` repository, delete all images older than 30 days (720h)
- From `another-project-id` project
  - in `test/os/centos` repository, delete all untagged images

```hcl
module "gcr_cleaner" {
  source  = "mirakl/gcr-cleaner/google"
  version = "x.y.z"

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
    },
    {
      project_id     = "another-project-id"
      repositories = [
        {
          # in `test/os/centos` repository, delete all untagged images
          name = "test/nginx"
        }
      ]
    }
  ]
  gar_repositories = [
    {
      name       = "foo"
      region     = "europe-west1"
      project_id = "foobar-123"
    }
  ]
}
```

- From `yet-another-project-id` project
  - in all repositories, delete all untagged images
  - in all repositories, keep 5 `beta` tags, ignore anything newer than 5 days
- From `automation-project-id` project
  - in in `test/tools/ci` repository and all its child repositories, keep only 5 tags

```hcl
module "gcr_cleaner" {
  source  = "mirakl/gcr-cleaner/google"
  version = "x.y.z"

  app_engine_application_location = "us-central"
  gcr_repositories = [
    {
      # in all repositories, delete all untagged images
      project_id     = "yet-another-project-id"
      clean_all      = true
    },
    {
      # in all repositories, keep 5 `beta` tags, ignore anything newer than 5 days
      project_id     = "yet-another-project-id"
      clean_all      = true
      parameters = {
        keep           = 5
        grace          = "120h"
        tag_filter_all = "^beta.+$"
      }
    }
  ]
}
```

## Examples

- [complete](examples/complete) - complete usage of the module (setting values for all variables)
- [minimal](examples/minimal) - minimal usage of the module (using default values for variables)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                           | Version   |
| ------------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform)       | >= 1.0.10 |
| <a name="requirement_google"></a> [google](#requirement_google)                | >= 4.1.0  |
| <a name="requirement_google-beta"></a> [google-beta](#requirement_google-beta) | >= 4.1.0  |

## Providers

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="provider_google"></a> [google](#provider_google)                | 4.6.0   |
| <a name="provider_google-beta"></a> [google-beta](#provider_google-beta) | 4.7.0   |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_artifact_registry_repository_iam_member.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository_iam_member) | resource |
| [google_app_engine_application.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_application) | resource |
| [google_cloud_run_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service) | resource |
| [google_cloud_run_service_iam_binding.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_binding) | resource |
| [google_cloud_scheduler_job.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |
| [google_project_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.cleaner](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket_access_control.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_access_control) | resource |
| [google_storage_bucket_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_engine_application_location"></a> [app\_engine\_application\_location](#input\_app\_engine\_application\_location) | The location to serve the app from. | `string` | `"europe-west1"` | no |
| <a name="input_cloud_run_service_location"></a> [cloud\_run\_service\_location](#input\_cloud\_run\_service\_location) | The location of the cloud run instance. Make sure to provide a valid location. More at https://cloud.google.com/run/docs/locations. | `string` | `"europe-west1"` | no |
| <a name="input_cloud_run_service_maximum_instances"></a> [cloud\_run\_service\_maximum\_instances](#input\_cloud\_run\_service\_maximum\_instances) | The number of maximum instances to set for this revision. This value will be used in the `autoscaling.knative.dev/maxScale` annotation key. | `number` | `100` | no |
| <a name="input_cloud_run_service_name"></a> [cloud\_run\_service\_name](#input\_cloud\_run\_service\_name) | The name of the cloud run service. | `string` | `"gcr-cleaner"` | no |
| <a name="input_cloud_run_service_timeout_seconds"></a> [cloud\_run\_service\_timeout\_seconds](#input\_cloud\_run\_service\_timeout\_seconds) | TimeoutSeconds holds the max duration the instance is allowed for responding to a request. | `number` | `60` | no |
| <a name="input_cloud_scheduler_job_attempt_deadline"></a> [cloud\_scheduler\_job\_attempt\_deadline](#input\_cloud\_scheduler\_job\_attempt\_deadline) | The deadline for job attempts in seconds. If the request handler does not respond by this deadline then the request is cancelled and the attempt is marked as a `DEADLINE_EXCEEDED` failure. The failed attempt can be viewed in execution logs. Cloud Scheduler will retry the job according to the `RetryConfig`. Value must be between 15 seconds and 24 hours | `number` | `320` | no |
| <a name="input_cloud_scheduler_job_max_backoff_duration"></a> [cloud\_scheduler\_job\_max\_backoff\_duration](#input\_cloud\_scheduler\_job\_max\_backoff\_duration) | The maximum amount of time to wait before retrying a job after it fails. A duration in seconds with up to nine fractional digits. | `number` | `3600` | no |
| <a name="input_cloud_scheduler_job_max_doublings"></a> [cloud\_scheduler\_job\_max\_doublings](#input\_cloud\_scheduler\_job\_max\_doublings) | The time between retries will double maxDoublings times. A job's retry interval starts at minBackoffDuration, then doubles maxDoublings times, then increases linearly, and finally retries retries at intervals of maxBackoffDuration up to retryCount times. | `number` | `5` | no |
| <a name="input_cloud_scheduler_job_max_retry_duration"></a> [cloud\_scheduler\_job\_max\_retry\_duration](#input\_cloud\_scheduler\_job\_max\_retry\_duration) | The time limit for retrying a failed job, measured from time when an execution was first attempted. If specified with retryCount, the job will be retried until both limits are reached. A duration in seconds with up to nine fractional digits. | `number` | `0` | no |
| <a name="input_cloud_scheduler_job_min_backoff_duration"></a> [cloud\_scheduler\_job\_min\_backoff\_duration](#input\_cloud\_scheduler\_job\_min\_backoff\_duration) | The minimum amount of time to wait before retrying a job after it fails. A duration in seconds with up to nine fractional digits. | `number` | `5` | no |
| <a name="input_cloud_scheduler_job_retry_count"></a> [cloud\_scheduler\_job\_retry\_count](#input\_cloud\_scheduler\_job\_retry\_count) | The number of attempts that the system will make to run a job using the exponential backoff procedure described by maxDoublings. Values greater than 5 and negative values are not allowed. | `number` | `1` | no |
| <a name="input_cloud_scheduler_job_schedule"></a> [cloud\_scheduler\_job\_schedule](#input\_cloud\_scheduler\_job\_schedule) | Describes the schedule on which the job will be executed. | `string` | `"0 4 * * 1"` | no |
| <a name="input_cloud_scheduler_job_time_zone"></a> [cloud\_scheduler\_job\_time\_zone](#input\_cloud\_scheduler\_job\_time\_zone) | Specifies the time zone to be used in interpreting schedule. The value of this field must be a time zone name from the tz database. More on https://en.wikipedia.org/wiki/List_of_tz_database_time_zones | `string` | `"Europe/Brussels"` | no |
| <a name="input_create_app_engine_app"></a> [create\_app\_engine\_app](#input\_create\_app\_engine\_app) | Whether to create an App Engine application. | `bool` | `false` | no |
| <a name="input_disable_dependent_services"></a> [disable\_dependent\_services](#input\_disable\_dependent\_services) | If `true`, services that are enabled and which depend on this service should also be disabled when this service is destroyed. If `false` or unset, an error will be generated if any enabled services depend on this service when destroying it. | `bool` | `false` | no |
| <a name="input_disable_on_destroy"></a> [disable\_on\_destroy](#input\_disable\_on\_destroy) | If `true`, disable the service when the terraform resource is destroyed. May be useful in the event that a project is long-lived but the infrastructure running in that project changes frequently. | `bool` | `false` | no |
| <a name="input_gar_repositories"></a> [gar\_repositories](#input\_gar\_repositories) | List of Google Artifact Registry objects:<pre>list(object({<br>    project_id = Value of the Google project id, if ommited, it will be assigned `google_project_id` local value, which is the provider's project_id (string)<br>    region     = Location of the storage bucket (string)<br>    name       = Name of the Artifact Registry repository (string)<br>    parameters = Map of parameters to apply to all repositories when `clean_all` is set to `true` (optional(object({<br>        grace          = Relative duration in which to ignore references. This value is specified as a time duration value like "5s" or "3h". If set, refs newer than the duration will not be deleted. If unspecified, the default is no grace period (all untagged image refs are deleted) (optional(string))<br>        keep           = If an integer is provided, it will always keep that minimum number of images. Note that it will not consider images inside the `grace` duration (optional(string))<br>        tag_filter     = (Deprecated) If specified, any image where the first tag matches this given regular expression will be deleted. The image will not be deleted if other tags match the regular expression (optional(string))<br>        tag_filter_any = If specified, any image with at least one tag that matches this given regular expression will be deleted. The image will be deleted even if it has other tags that do not match the given regular expression (optional(string))<br>        tag_filter_all = If specified, any image where all tags match this given regular expression will be deleted. The image will not be delete if it has other tags that do not match the given regular expression (optional(string))<br>    })))<br>}))</pre> | <pre>list(object({<br>    project_id = optional(string)<br>    region     = string<br>    name       = string<br>    parameters = optional(object({<br>      grace          = optional(string)<br>      keep           = optional(string)<br>      tag_filter     = optional(string)<br>      tag_filter_any = optional(string)<br>      tag_filter_all = optional(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_gcr_cleaner_image"></a> [gcr\_cleaner\_image](#input\_gcr\_cleaner\_image) | The docker image of the gcr cleaner to deploy to Cloud Run. | `string` | `"gcr.io/gcr-cleaner/gcr-cleaner:latest"` | no |
| <a name="input_gcr_repositories"></a> [gcr\_repositories](#input\_gcr\_repositories) | List of Google Container Registries objects to create:<pre>list(object({<br>    project_id     = Value of the Google project id, if ommited, it will be assigned `google_project_id` local value, which is the provider's project_id (optional(string))<br>    storage_region = Location of the storage bucket (optional(string))<br>    repositories = Docker image repositories to clean (optional(list(object({<br>      name           = Name of the repository (string)<br>      grace          = Relative duration in which to ignore references. This value is specified as a time duration value like "5s" or "3h". If set, refs newer than the duration will not be deleted. If unspecified, the default is no grace period (all untagged image refs are deleted) (optional(string))<br>      keep           = If an integer is provided, it will always keep that minimum number of images. Note that it will not consider images inside the `grace` duration (optional(string))<br>      tag_filter     = (Deprecated) If specified, any image where the first tag matches this given regular expression will be deleted. The image will not be deleted if other tags match the regular expression (optional(string))<br>      tag_filter_any = If specified, any image with at least one tag that matches this given regular expression will be deleted. The image will be deleted even if it has other tags that do not match the given regular expression (optional(string))<br>      tag_filter_all = If specified, any image where all tags match this given regular expression will be deleted. The image will not be delete if it has other tags that do not match the given regular expression (optional(string))<br>      recursive      = If set to true, will recursively search all child repositories (optional(bool))<br>    }))))<br>    clean_all  = Set to `true` to clean all project's repositories (optional(bool))<br>    parameters = Map of parameters to apply to all repositories when `clean_all` is set to `true` (optional(object({<br>      grace          = Relative duration in which to ignore references. This value is specified as a time duration value like "5s" or "3h". If set, refs newer than the duration will not be deleted. If unspecified, the default is no grace period (all untagged image refs are deleted) (optional(string))<br>      keep           = If an integer is provided, it will always keep that minimum number of images. Note that it will not consider images inside the `grace` duration (optional(string))<br>      tag_filter     = (Deprecated) If specified, any image where the first tag matches this given regular expression will be deleted. The image will not be deleted if other tags match the regular expression (optional(string))<br>      tag_filter_any = If specified, any image with at least one tag that matches this given regular expression will be deleted. The image will be deleted even if it has other tags that do not match the given regular expression (optional(string))<br>      tag_filter_all = If specified, any image where all tags match this given regular expression will be deleted. The image will not be delete if it has other tags that do not match the given regular expression (optional(string))<br>    })))<br>}))</pre> | <pre>list(object({<br>    project_id     = optional(string)<br>    storage_region = optional(string)<br>    repositories = optional(list(object({<br>      name           = string<br>      grace          = optional(string)<br>      keep           = optional(string)<br>      tag_filter     = optional(string)<br>      tag_filter_any = optional(string)<br>      tag_filter_all = optional(string)<br>      recursive      = optional(bool)<br>    })))<br>    clean_all = optional(bool)<br>    parameters = optional(object({<br>      grace          = optional(string)<br>      keep           = optional(string)<br>      tag_filter     = optional(string)<br>      tag_filter_any = optional(string)<br>      tag_filter_all = optional(string)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name                                                                                                                 | Description                             |
| -------------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| <a name="output_app_engine_application_name"></a> [app_engine_application_name](#output_app_engine_application_name) | The name of the app engine application. |
| <a name="output_cloud_run_service_id"></a> [cloud_run_service_id](#output_cloud_run_service_id)                      | The ID of the cloud run service.        |
| <a name="output_cloud_scheduler_jobs"></a> [cloud_scheduler_jobs](#output_cloud_scheduler_jobs)                      | List of the created scheduler jobs.     |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
