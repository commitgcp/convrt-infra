# Cloud Run

Create Cloud Run Services + option of having Load Balancers

Folder structure:

- `lb/external`: Attach external load balancer to Cloud Run Service.
- `lb/http-internal-lb`: Attach internal HTTP Load Balancer to Cloud Run Service.
- `lb/http-internal-lb/vm`: (Optional) Internal Load Balancer requires at least one running VM on ILB Region.

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
| <a name="module_elb"></a> [elb](#module\_elb) | ./lb/external | n/a |
| <a name="module_ilb"></a> [ilb](#module\_ilb) | ./lb/http-internal-lb | n/a |

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_service.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service) | resource |
| [google_cloud_run_service_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_policy) | resource |
| [google_project_iam_member.cloud_run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.cloud_run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_unauthenticated"></a> [allow\_unauthenticated](#input\_allow\_unauthenticated) | Allow unauthenticated cloud run invocations | `bool` | `false` | no |
| <a name="input_container_concurrency"></a> [container\_concurrency](#input\_container\_concurrency) | Container concurrency. Number of request to process per container | `number` | `80` | no |
| <a name="input_create_sa"></a> [create\_sa](#input\_create\_sa) | Create service account for Cloud Run service | `bool` | `false` | no |
| <a name="input_elb_config"></a> [elb\_config](#input\_elb\_config) | Cloud Run Service to attach External Load Balancer | <pre>object({<br>    enable_cdn                      = optional(bool, false)<br>    ssl                             = optional(bool, false)<br>    managed_ssl_certificate_domains = optional(list(string), [])<br>    https_redirect                  = optional(bool, false)<br>    log_config = optional(object({<br>      enable      = optional(bool, false)<br>      sample_rate = optional(number, 1.0)<br>    }))<br><br>    iap_config = optional(object({<br>      enable               = optional(bool, false)<br>      oauth2_client_id     = optional(string)<br>      oauth2_client_secret = optional(string)<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_env_secret_vars"></a> [env\_secret\_vars](#input\_env\_secret\_vars) | Secret environment variables (From Secret Manager). Key is Environment variable name and value is secret manager secret name | `map(string)` | `{}` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Environment variables (cleartext). Key is Environment variable name and value is env variable value | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Cloud Run Service environment. Example: dev, staging, qa, prod | `string` | n/a | yes |
| <a name="input_ilb_config"></a> [ilb\_config](#input\_ilb\_config) | Cloud Run Service to attach internal Load Balancer | <pre>object({<br>    network    = string<br>    subnetwork = string<br>  })</pre> | `null` | no |
| <a name="input_image"></a> [image](#input\_image) | Cloud Run image | `string` | `"gcr.io/cloudrun/hello"` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Acceptable values all, internal, internal-and-cloud-load-balancing | `string` | `"all"` | no |
| <a name="input_limits"></a> [limits](#input\_limits) | Resource limits to the container. cpu = (core count * 1000)m, memory = (size) in Mi/Gi | <pre>object({<br>    cpu    = string<br>    memory = string<br>  })</pre> | <pre>{<br>  "cpu": "1000m",<br>  "memory": "128Mi"<br>}</pre> | no |
| <a name="input_port"></a> [port](#input\_port) | Port which the container listens to | `number` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | ############## ## General ### ############## | `string` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | Port protocol to use. Options http1 or h2c (grpc) | `string` | `"http1"` | no |
| <a name="input_region"></a> [region](#input\_region) | Cloud Run Region | `string` | n/a | yes |
| <a name="input_request_timeout_seconds"></a> [request\_timeout\_seconds](#input\_request\_timeout\_seconds) | The max duration the instance is allowed for responding to a request | `number` | `300` | no |
| <a name="input_sa_permission"></a> [sa\_permission](#input\_sa\_permission) | Service Account (if created) permission | `list(string)` | `[]` | no |
| <a name="input_service"></a> [service](#input\_service) | Cloud Run Service | `string` | n/a | yes |
| <a name="input_template_annotations"></a> [template\_annotations](#input\_template\_annotations) | Annotations to the container metadata including VPC Connector and SQL. See [more details](https://cloud.google.com/run/docs/reference/rpc/google.cloud.run.v1#revisiontemplate) | `map(string)` | <pre>{<br>  "autoscaling.knative.dev/maxScale": 2,<br>  "autoscaling.knative.dev/minScale": 1,<br>  "generated-by": "terraform",<br>  "run.googleapis.com/client-name": "terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_url"></a> [url](#output\_url) | The URL where the service is available |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->