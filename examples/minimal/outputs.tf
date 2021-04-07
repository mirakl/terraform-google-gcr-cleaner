output "cloud_run_service_id" {
  description = "The ID of the cloud run service."
  value       = module.gcr_cleaner.cloud_run_service_id
}

output "app_engine_application_name" {
  description = "The name of the app engine application."
  value       = module.gcr_cleaner.app_engine_application_name
}

output "cloud_scheduler_jobs" {
  description = "List of the created scheduler jobs."
  value       = module.gcr_cleaner.cloud_scheduler_jobs
}
