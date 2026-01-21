output "cloud_run_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.app.status[0].url
}

output "storage_bucket_name" {
  description = "Name of the Cloud Storage bucket"
  value       = google_storage_bucket.artifacts.name
}

output "database_connection_name" {
  description = "Connection name for Cloud SQL instance"
  value       = google_sql_database_instance.postgres.connection_name
}

output "database_instance_name" {
  description = "Name of the Cloud SQL instance"
  value       = google_sql_database_instance.postgres.name
}


