# ##############
# ### BUCKET ###
# ##############
# output "bucket_name" {
#   value = google_storage_bucket.website.name
# }

# output "bucket_url" {
#   value = google_storage_bucket.website.url
# }

# output "bucket_self_link" {
#   value = google_storage_bucket.website.self_link
# }

# output "bucket_id" {
#   value = google_storage_bucket.website.id
# }

# output "bucket_project" {
#   value = google_storage_bucket.website.project
# }

# output "bucket_location" {
#   value = google_storage_bucket.website.location
# }

# output "bucket_storage_class" {
#   value = google_storage_bucket.website.storage_class
# }

# ##############
# ### LB-CDN ###
# ##############
# output "lb_static_ip" {
#   #value = module.gcs-lb-cdn[0].lb_static_ip
#   value = module.gcs-lb-cdn.*.lb_static_ip
# }

# output "lb_static_ip_address" {
#   #  value = module.gcs-lb-cdn[0].lb_static_ip_address
#   value = module.gcs-lb-cdn.*.lb_static_ip_address
# }

# output "lb_static_ip_name" {
#   #  value = module.gcs-lb-cdn[0].lb_static_ip_name
#   value = module.gcs-lb-cdn.*.lb_static_ip_name
# }

# output "lb_static_ip_self_link" {
#   #  value = module.gcs-lb-cdn[0].lb_static_ip_self_link
#   value = module.gcs-lb-cdn.*.lb_static_ip_self_link
# }

# output "lb_static_ip_id" {
#   #  value = module.gcs-lb-cdn[0].lb_static_ip_id
#   value = module.gcs-lb-cdn.*.lb_static_ip_id
# }
