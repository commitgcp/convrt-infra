<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_backend_bucket.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_bucket) | resource |
| [google_compute_global_address.lb_static_ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_global_forwarding_rule.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_target_http_proxy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_url_map.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Bucket to enable CDN | `string` | n/a | yes |
| <a name="input_cdn"></a> [cdn](#input\_cdn) | CDN configuration | <pre>object({<br>    cache_mode        = optional(string, "CACHE_ALL_STATIC")<br>    client_ttl        = optional(number, 3600)<br>    default_ttl       = optional(number, 3600)<br>    max_ttl           = optional(number, 86400)<br>    negative_caching  = optional(bool, true)<br>    serve_while_stale = optional(number, 86400)<br>  })</pre> | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Network project ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_bucket"></a> [backend\_bucket](#output\_backend\_bucket) | ############## ## Backend ### ############## |
| <a name="output_forwarding_rule"></a> [forwarding\_rule](#output\_forwarding\_rule) | ###################### ## Forwarding Rule ### ###################### |
| <a name="output_http_proxy"></a> [http\_proxy](#output\_http\_proxy) | n/a |
| <a name="output_lb_static_ip"></a> [lb\_static\_ip](#output\_lb\_static\_ip) | ################### ## LB Static IP ### ################### |
| <a name="output_url_map"></a> [url\_map](#output\_url\_map) | n/a |
<!-- END_TF_DOCS -->