module "sql" {
  source  = "../modules/sql"
  project = var.project_id
  region  = var.region
  sql     = var.sql
  network = {
    name                = var.sql_network.name
    enable_public_ip    = true
    require_ssl         = false
    authorized_networks = []
    allocated_ip_range  = var.sql_network.allocated_ip_range
  }
  backup_configuration = var.sql_backup_configuration
}