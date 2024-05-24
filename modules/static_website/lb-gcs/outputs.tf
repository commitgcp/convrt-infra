# create outputs for resources
output "lb_static_ip" {
  value = google_compute_global_address.lb_static_ip
}

output "lb_static_ip_address" {
  value = google_compute_global_address.lb_static_ip.address
}

output "lb_static_ip_name" {
  value = google_compute_global_address.lb_static_ip.name
}

output "lb_static_ip_self_link" {
  value = google_compute_global_address.lb_static_ip.self_link
}

output "lb_static_ip_id" {
  value = google_compute_global_address.lb_static_ip.id
}

output "backend_bucket" {
  value = google_compute_backend_bucket.default.name
}

output "backend_bucket_id" {
  value = google_compute_backend_bucket.default.id
}

output "backend_bucket_self_link" {
  value = google_compute_backend_bucket.default.self_link
}

output "backend_bucket_bucket_name" {
  value = google_compute_backend_bucket.default.bucket_name
}

output "target_http_proxy" {
  value = google_compute_target_http_proxy.default.name
}

output "global_forwarding_rule" {
  value = google_compute_global_forwarding_rule.default.name
}

output "global_forwarding_rule_id" {
  value = google_compute_global_forwarding_rule.default.id
}

output "global_forwarding_rule_self_link" {
  value = google_compute_global_forwarding_rule.default.self_link
}

output "global_forwarding_rule_ip_address" {
  value = google_compute_global_forwarding_rule.default.ip_address
}