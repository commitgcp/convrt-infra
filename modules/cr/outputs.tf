output "url" {
  value       = google_cloud_run_service.default.status[0].url
  description = "The URL where the service is available"
}