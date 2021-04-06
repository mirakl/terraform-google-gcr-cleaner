output "cloud_run_service_id" {
  description = "The ID of the cloud run service."
  value       = google_cloud_run_service.this.id
}

output "app_engine_application_id" {
  description = "The ID of the app engine application."
  value       = var.create_app_engine_app ? google_app_engine_application.this[0].app_id : ""
}

output "cloud_scheduler_jobs" {
  description = "List of the created scheduler jobs."
  value = [
    for job in google_cloud_scheduler_job.this : {
      id : job.id
      name : job.name
    }
  ]
}
