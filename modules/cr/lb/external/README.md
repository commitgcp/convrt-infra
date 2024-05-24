<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lb-http"></a> [lb-http](#module\_lb-http) | GoogleCloudPlatform/lb-http/google//modules/serverless_negs | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_region_network_endpoint_group.cloudrun_neg](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_elb_config"></a> [elb\_config](#input\_elb\_config) | External Load Balancer configuration | <pre>object({<br>    enable_cdn                      = optional(bool, false)<br>    ssl                             = optional(bool, false)<br>    managed_ssl_certificate_domains = optional(list(string), [])<br>    https_redirect                  = optional(bool, false)<br>    log_config = optional(object({<br>      enable      = optional(bool, false)<br>      sample_rate = optional(number, 1.0)<br>    }))<br><br>    iap_config = optional(object({<br>      enable               = optional(bool, false)<br>      oauth2_client_id     = optional(string)<br>      oauth2_client_secret = optional(string)<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | ############## ## General ### ############## | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Cloud Run service to attach external load balancer | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->