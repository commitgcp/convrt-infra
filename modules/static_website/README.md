# Terraform Modules Template

Put a short description of what this module does.

<!-- terraform-docs output will go here -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcs-lb-cdn"></a> [gcs-lb-cdn](#module\_gcs-lb-cdn) | ./lb-gcs | n/a |

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.website](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.public](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_labels"></a> [bucket\_labels](#input\_bucket\_labels) | The labels of the bucket | `map(string)` | `{}` | no |
| <a name="input_bucket_location"></a> [bucket\_location](#input\_bucket\_location) | The location of the bucket | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the bucket | `string` | n/a | yes |
| <a name="input_bucket_public"></a> [bucket\_public](#input\_bucket\_public) | Make bucket public | `bool` | `true` | no |
| <a name="input_bucket_storage_class"></a> [bucket\_storage\_class](#input\_bucket\_storage\_class) | The storage class of the bucket | `string` | `"STANDARD"` | no |
| <a name="input_bucket_versioning_enabled"></a> [bucket\_versioning\_enabled](#input\_bucket\_versioning\_enabled) | The versioning of the bucket | `bool` | `true` | no |
| <a name="input_cdn"></a> [cdn](#input\_cdn) | CDN configuration | <pre>object({<br>    enable            = optional(bool, false)<br>    cache_mode        = optional(string, "CACHE_ALL_STATIC")<br>    client_ttl        = optional(number, 3600)<br>    default_ttl       = optional(number, 3600)<br>    max_ttl           = optional(number, 86400)<br>    negative_caching  = optional(bool, true)<br>    serve_while_stale = optional(number, 86400)<br>  })</pre> | <pre>{<br>  "enable": false<br>}</pre> | no |
| <a name="input_cors"></a> [cors](#input\_cors) | The cors of the bucket | <pre>object({<br>    origin          = optional(list(string), ["*"])<br>    method          = optional(list(string), ["GET", "OPTIONS", "POST"])<br>    response_header = optional(list(string), ["*"])<br>    max_age_seconds = optional(number, 3600)<br>  })</pre> | `null` | no |
| <a name="input_enable_lb"></a> [enable\_lb](#input\_enable\_lb) | Enable LB | `bool` | `false` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the resource belongs | `string` | n/a | yes |
| <a name="input_ssl"></a> [ssl](#input\_ssl) | SSL configuration | <pre>object({<br>    enable       = optional(bool, false)<br>    certificates = optional(list(string), [])<br>  })</pre> | <pre>{<br>  "enable": false<br>}</pre> | no |
| <a name="input_website_main_page_file"></a> [website\_main\_page\_file](#input\_website\_main\_page\_file) | The main page of the bucket | `string` | `"index.html"` | no |
| <a name="input_website_not_found_page"></a> [website\_not\_found\_page](#input\_website\_not\_found\_page) | The not found page of the bucket | `string` | `"404.html"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | n/a |
| <a name="output_bucket_location"></a> [bucket\_location](#output\_bucket\_location) | n/a |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | ############# ## BUCKET ### ############# |
| <a name="output_bucket_project"></a> [bucket\_project](#output\_bucket\_project) | n/a |
| <a name="output_bucket_self_link"></a> [bucket\_self\_link](#output\_bucket\_self\_link) | n/a |
| <a name="output_bucket_storage_class"></a> [bucket\_storage\_class](#output\_bucket\_storage\_class) | n/a |
| <a name="output_bucket_url"></a> [bucket\_url](#output\_bucket\_url) | n/a |
| <a name="output_lb_static_ip"></a> [lb\_static\_ip](#output\_lb\_static\_ip) | ############# ## LB-CDN ### ############# |
| <a name="output_lb_static_ip_address"></a> [lb\_static\_ip\_address](#output\_lb\_static\_ip\_address) | n/a |
| <a name="output_lb_static_ip_id"></a> [lb\_static\_ip\_id](#output\_lb\_static\_ip\_id) | n/a |
| <a name="output_lb_static_ip_name"></a> [lb\_static\_ip\_name](#output\_lb\_static\_ip\_name) | n/a |
| <a name="output_lb_static_ip_self_link"></a> [lb\_static\_ip\_self\_link](#output\_lb\_static\_ip\_self\_link) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

