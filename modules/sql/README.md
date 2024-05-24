# Terraform Modules Template

Put a short description of what this module does.

<!-- terraform-docs output will go here -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_postgresql"></a> [postgresql](#module\_postgresql) | GoogleCloudPlatform/sql-db/google//modules/postgresql | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set. | <pre>list(object({<br>    name            = string<br>    password        = string<br>    random_password = bool<br>  }))</pre> | `[]` | no |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | The backup\_configuration settings subblock for the database setings | <pre>object({<br>    enabled                        = bool<br>    start_time                     = optional(string)<br>    location                       = optional(string)<br>    point_in_time_recovery_enabled = optional(bool, false)<br>    transaction_log_retention_days = optional(string)<br>    retained_backups               = optional(number)<br>    retention_unit                 = optional(string)<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_network"></a> [network](#input\_network) | n/a | <pre>object({<br>    name             = optional(string)<br>    enable_public_ip = optional(bool, true)<br>    require_ssl      = optional(bool, true)<br>    authorized_networks = optional(list(object({<br>      name  = string<br>      value = string<br>    })), [])<br>    allocated_ip_range = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project ID to deploy resources into | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to deploy resources into | `string` | n/a | yes |
| <a name="input_sql"></a> [sql](#input\_sql) | ################ ## Cloud SQL ### ################ | <pre>object({<br>    engine            = optional(string, "postgresql")<br>    instance_name     = string<br>    db_name           = string<br>    database_version  = string<br>    tier              = string<br>    zone              = string<br>    availability_type = string<br>    disk_size         = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->