# terraform-google-gcr-cleaner-complete-example

Complete usage of the module (setting values for all variables)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.10 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 2.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.1.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcr_cleaner"></a> [gcr\_cleaner](#module\_gcr\_cleaner) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | The project ID to create resources under. | `string` | `"project-terraform-test-dcbe3d0"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where resources will be created. | `string` | `"europe-west3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_engine_application_name"></a> [app\_engine\_application\_name](#output\_app\_engine\_application\_name) | The name of the app engine application. |
| <a name="output_cloud_run_service_id"></a> [cloud\_run\_service\_id](#output\_cloud\_run\_service\_id) | The ID of the cloud run service. |
| <a name="output_cloud_scheduler_jobs"></a> [cloud\_scheduler\_jobs](#output\_cloud\_scheduler\_jobs) | List of the created scheduler jobs. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
