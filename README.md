# terraform-google-gcr-cleaner

Terraform module that implements [gcr-cleaner](https://github.com/sethvargo/gcr-cleaner), a tool that deletes untagged images in [Google Cloud Container Registry](https://cloud.google.com/container-registry).

## Prerequisites

Please install:
* [gcloud](https://cloud.google.com/sdk/gcloud/)
* [jq](https://stedolan.github.io/jq/)

## Usage
* From current project (the provider's project)
  * in `test/nginx` repository, delete all untagged images
  * in `test/python` repository, delete all images older than 30 days (720h)
* From `another-project-id` project
  * in `test/os/centos` repository, delete all untagged images

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
}
```

* From `yet-another-project-id` project
  * in all repositories, delete all untagged images
  * in all repositories, keep 5 `beta` tags, ignore anything newer than 5 days
* From `automation-project-id` project
  * in in `test/tools/ci` repository and all its child repositories, keep only 5 tags

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
        allow_tagged = true
        keep         = 5
        grace        = "120h"
        tag_filter   = "^beta.+$"
      }
    },
    {
      project_id     = "automation-project-id"
      repositories = [
        {
          # in `test/tools/ci` repository and all its child repositories, keep only 5 tags
          name         = "test/tools/ci"
          allow_tagged = true
          keep         = 5
          recursive    = true
        }
      ]
    }
  ]
}
```

> To fetch all repositories for a given project, this module is using an [external data source](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/data_source) running a [local script](scripts/get_all_repositories.sh) that build the list of repositories with the help of [gcloud](https://cloud.google.com/sdk/gcloud/) and [jq](https://stedolan.github.io/jq/) commands.

## Examples

* [complete](examples/complete) - complete usage of the module (setting values for all variables)
* [minimal](examples/minimal) - minimal usage of the module (using default values for variables)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.10 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 2.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.1.0 |
| <a name="provider_google"></a> [google](#provider\_google) | 4.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_app_engine_application.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_application) | resource |
| [google_cloud_run_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service) | resource |
| [google_cloud_run_service_iam_binding.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_binding) | resource |
| [google_cloud_scheduler_job.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |
| [google_project_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.cleaner](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket_access_control.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_access_control) | resource |
| [external_external.this](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

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
| <a name="input_gcr_cleaner_image"></a> [gcr\_cleaner\_image](#input\_gcr\_cleaner\_image) | The docker image of the gcr cleaner to deploy to Cloud Run. | `string` | `"gcr.io/gcr-cleaner/gcr-cleaner"` | no |
| <a name="input_gcr_repositories"></a> [gcr\_repositories](#input\_gcr\_repositories) | List of Google Container Registries objects to create:<pre>list(object({<br>    project_id      = Value of the Google project id, if ommited, it will be assigned `google_project_id` variable value (optional(string))<br>    storage_region  = Location of the storage bucket (optional(string))<br>    repositories    = Docker image repositories to clean (optional(list(object({<br>      name         = Name of the repository (string)<br>      grace        = Relative duration in which to ignore references. This value is specified as a time duration value like "5s" or "3h". If set, refs newer than the duration will not be deleted. If unspecified, the default is no grace period (all untagged image refs are deleted) (optional(string))<br>      allow_tagged = If set to true, will check all images including tagged. If unspecified, the default will only delete untagged images (optional(bool))<br>      keep         = If an integer is provided, it will always keep that minimum number of images. Note that it will not consider images inside the `grace` duration (optional(string))<br>      tag_filter   = Used for tags regexp definition to define pattern to clean, requires `allow_tagged` must be true. For example: use `"^dev.+$"` to limit cleaning only on the tags with beginning with is `dev`. The default is no filtering (optional(string))<br>    }))))<br>    clean_all       = Set to `true` to clean all project's repositories (optional(bool))<br>    parameters      = Map of parameters to apply to all repositories when `clean_all` is set to `true` (optional(object({<br>      grace        = Relative duration in which to ignore references. This value is specified as a time duration value like "5s" or "3h". If set, refs newer than the duration will not be deleted. If unspecified, the default is no grace period (all untagged image refs are deleted) (optional(string))<br>      allow_tagged = If set to true, will check all images including tagged. If unspecified, the default will only delete untagged images (optional(bool))<br>      keep         = If an integer is provided, it will always keep that minimum number of images. Note that it will not consider images inside the `grace` duration (optional(string))<br>      tag_filter   = Used for tags regexp definition to define pattern to clean, requires `allow_tagged` must be true. For example: use `"^dev.+$"` to limit cleaning only on the tags with beginning with is `dev`. The default is no filtering (optional(string))<br>    })))<br>}))</pre> | <pre>list(object({<br>    project_id     = optional(string)<br>    storage_region = optional(string)<br>    repositories = optional(list(object({<br>      name         = string<br>      grace        = optional(string)<br>      allow_tagged = optional(bool)<br>      keep         = optional(string)<br>      tag_filter   = optional(string)<br>    })))<br>    clean_all = optional(bool)<br>    parameters = optional(object({<br>      grace        = optional(string)<br>      allow_tagged = optional(bool)<br>      keep         = optional(string)<br>      tag_filter   = optional(string)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_engine_application_name"></a> [app\_engine\_application\_name](#output\_app\_engine\_application\_name) | The name of the app engine application. |
| <a name="output_cloud_run_service_id"></a> [cloud\_run\_service\_id](#output\_cloud\_run\_service\_id) | The ID of the cloud run service. |
| <a name="output_cloud_scheduler_jobs"></a> [cloud\_scheduler\_jobs](#output\_cloud\_scheduler\_jobs) | List of the created scheduler jobs. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
