# terraform-gcr-cleaner

Terraform module that implements [gcr-cleaner](https://github.com/sethvargo/gcr-cleaner), a tool that deletes untagged images in [Google Cloud Container Registry](https://cloud.google.com/container-registry).

This type of resources are supported:

* [google_cloud_run_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service)
* [google_app_engine_application](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_application)
* [google_cloud_scheduler_job](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) 
* [google_project_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service)
* [google_storage_bucket_access_control](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_access_control)
* [google_cloud_run_service_iam_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam#google_cloud_run_service_iam_binding)
* [google_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account)

## Usage

```hcl
module "gcr_cleaner" {
  source = "../.."

  google_project_id = var.google_project_id
  create_app_engine_app = false
  app_engine_application_location = "europe-west3"
  gcr_repositories = [
    {
      storage_region = "eu"
      repositories = [
        "test/nginx",
        "test/db/mariadb",
      ]
    },
    {
      project_id     = "another-project-id"
      repositories = [
        "test/os/centos",
      ]
    }
  ]
}
```

## Examples

* [complete](examples/complete) - complete usage of the module (setting values for all variables)
* [minimal](examples/minimal) - minimal usage of the module (using default values for variables)

## TODO

This version of the module implements just `repo` parameter of the `gcr-cleaner` payload. [Other parameters](https://github.com/sethvargo/gcr-cleaner#payload--parameters) will be implemented in future versions. 

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.9 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.62.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.62.0 |

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_engine_application_location"></a> [app\_engine\_application\_location](#input\_app\_engine\_application\_location) | The location to serve the app from. | `string` | `"europe-west1"` | no |
| <a name="input_cloud_run_service_location"></a> [cloud\_run\_service\_location](#input\_cloud\_run\_service\_location) | The location of the cloud run instance. Make sure to provide a valid location. More at https://cloud.google.com/run/docs/locations | `string` | `"europe-west1"` | no |
| <a name="input_cloud_run_service_name"></a> [cloud\_run\_service\_name](#input\_cloud\_run\_service\_name) | The name of the cloud run service. | `string` | `"gcr-cleaner"` | no |
| <a name="input_cloud_scheduler_job_schedule"></a> [cloud\_scheduler\_job\_schedule](#input\_cloud\_scheduler\_job\_schedule) | Describes the schedule on which the job will be executed. | `string` | `"0 4 * * 1"` | no |
| <a name="input_cloud_scheduler_job_time_zone"></a> [cloud\_scheduler\_job\_time\_zone](#input\_cloud\_scheduler\_job\_time\_zone) | Specifies the time zone to be used in interpreting schedule. The value of this field must be a time zone name from the tz database. More on https://en.wikipedia.org/wiki/List_of_tz_database_time_zones | `string` | `"Europe/Brussels"` | no |
| <a name="input_create_app_engine_app"></a> [create\_app\_engine\_app](#input\_create\_app\_engine\_app) | Whether to create an App Engine application. | `bool` | `true` | no |
| <a name="input_disable_dependent_services"></a> [disable\_dependent\_services](#input\_disable\_dependent\_services) | If `true`, services that are enabled and which depend on this service should also be disabled when this service is destroyed. If `false` or unset, an error will be generated if any enabled services depend on this service when destroying it. | `bool` | `false` | no |
| <a name="input_disable_on_destroy"></a> [disable\_on\_destroy](#input\_disable\_on\_destroy) | If `true`, disable the service when the terraform resource is destroyed. May be useful in the event that a project is long-lived but the infrastructure running in that project changes frequently. | `bool` | `false` | no |
| <a name="input_gcr_cleaner_image"></a> [gcr\_cleaner\_image](#input\_gcr\_cleaner\_image) | The docker image of the gcr cleaner to deploy to Cloud Run. | `string` | `"gcr.io/gcr-cleaner/gcr-cleaner"` | no |
| <a name="input_gcr_repositories"></a> [gcr\_repositories](#input\_gcr\_repositories) | List of Google Container Registries objects. | <pre>list(object({<br>    # google project id, if ommited, it will be assigned `google_project_id` variable value<br>    project_id = optional(string)<br>    # location of the storage bucket<br>    storage_region = optional(string)<br>    # docker image repositories<br>    repositories = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | The project ID to create resources under. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_engine_application_id"></a> [app\_engine\_application\_id](#output\_app\_engine\_application\_id) | The ID of the app engine application. |
| <a name="output_cloud_run_service_id"></a> [cloud\_run\_service\_id](#output\_cloud\_run\_service\_id) | The ID of the cloud run service. |
| <a name="output_cloud_scheduler_jobs"></a> [cloud\_scheduler\_jobs](#output\_cloud\_scheduler\_jobs) | List of the created scheduler jobs. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
