<!-- BEGIN_TF_DOCS -->


## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_slackbot"></a> [slackbot](#module\_slackbot) | ../ | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of your function | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Any additional environment variables you want inside the Slackbot Functions | `map(any)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of your function | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | The path of your function | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project you wish to deploy the Slackbot Functions in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region the Slackbots will be deployed into | `string` | n/a | yes |
| <a name="input_slack_secret"></a> [slack\_secret](#input\_slack\_secret) | The Slack API secret that you will be deploying - will be wrapped into a Google Secret and deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_url"></a> [url](#output\_url) | n/a |
<!-- END_TF_DOCS -->