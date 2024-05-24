#################
### Cloud Run ###
#################
module "cloud_run" {
  for_each      = var.cr_services
  source        = "../modules/cr"
  project       = var.project_id
  region        = var.region
  service       = each.key
  port          = 80
  create_sa     = each.value.create_sa
  sa_permission = each.value.sa_permission
  elb_config    = each.value.elb_config
  depends_on    = [google_project_service.api]
}