# slackbot-cloud-function
A Cloud Function driven Slackbot that responds to `/slash` commands! :robot:

![TFSec Security Checks](https://github.com/withriley/slackbot-cloud-function/actions/workflows/main.yml/badge.svg)
![terraform-docs](https://github.com/withriley/slackbot-cloud-function/actions/workflows/terraform-docs.yml/badge.svg)
![auto-release](https://github.com/withriley/slackbot-cloud-function/actions/workflows/release.yml/badge.svg)
![bandit python security](https://github.com/withriley/slackbot-cloud-function/actions/workflows/bandit.yml/badge.svg)

## Architecture

![architecture diagram](images/architecture_slack.png)

## Slackbot Usage Instructions

1. Consume the module in your Terraform using the syntax in the [`/examples`](examples/README.md) folder. Or see `Examples` section below!
2. You will need to provide your Python function that will act as the Worker instance to perform the commands that you want. An example of what this looks like can be found in [`/examples`](examples/worker_function_example)
3. You will need to generate a new [Slack App](https://api.slack.com/apps/) and get the 'Signing Secret' from the main page - this will need to be used for the `var.slack_secret` variable.
4. Once the Cloud Function has been spun up you can use the ouput `"function_url"` to get the `http` link for use in creating a new `/slash` command. This can be created in the `Slash Commands` section of your new Slack App.
5. Once the command is created and the Slack App installed into your Slack org you can begin using it!

## Requirements

1. This module enables them but the following APIs are required to be enabled:
   1. Pub/Sub
   2. Cloud Functions
   3. Secrets Manager
   4. Cloud Build
2. You will also need to be able to add unauthenticated users to the IAM invokers so any org policies enforcing authenticated users will break this. Review your org policies first!

## Template Usage Instructions :sparkles:

1. Ensure you create your Terraform Module in the root of this directory
2. Create new examples in `/examples/`
3. Create new releases by creating tags with the name `v220317` - e.g. version by v-Year-Month-Day - also known as CalVer

## GitHub Actions

This repo has 4 built in GitHub Actions:

1. Security scan using tfsec - ensure no IaC errors. To delete remove the file `.github/workflows/main.yml`
2. Terraform-Docs - documentation is automatically taken care of by Terraform-Docs which fills in info in the `README.md` of each section.
3. Automated release - Create new releases by creating tags with the name `v220317` - e.g. version by v-Year-Month-Day - also known as CalVer.
4. Bandit Python Security Checks.

<!-- BEGIN_TF_DOCS -->


## Example

```hcl
module "slackbot" {
  source                = "../"
  name                  = var.name
  path                  = var.path
  description           = var.description
  project               = var.project
  region                = var.region
  slack_secret          = var.slack_secret
  environment_variables = var.environment_variables
}

output "url" {
  value = module.slackbot.function_url
}
```

## Resources

| Name | Type |
|------|------|
| [google_cloudfunctions_function.function](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function) | resource |
| [google_cloudfunctions_function_iam_member.invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function_iam_member) | resource |
| [google_project_iam_binding.project_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_service.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_pubsub_topic.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_secret_manager_secret.secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.zip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [archive_file.source](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Modules

No modules.

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
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | The URL that will need to be provided to your Slackbot. |
<!-- END_TF_DOCS -->

## Detailed TF Module Requirements :books:

1. Root module. This is the only required element for the standard module structure. Terraform files must exist in the root directory of the repository. This should be the primary entrypoint for the module and is expected to be opinionated. For the Consul module the root module sets up a complete Consul cluster. It makes a lot of assumptions however, and we expect that advanced users will use specific nested modules to more carefully control what they want.

2. README. The root module and any nested modules should have README files. This file should be named README or README.md. The latter will be treated as markdown. There should be a description of the module and what it should be used for. If you want to include an example for how this module can be used in combination with other resources, put it in an examples directory like this. Consider including a visual diagram depicting the infrastructure resources the module may create and their relationship.

3. LICENSE. The license under which this module is available. If you are publishing a module publicly, many organizations will not adopt a module unless a clear license is present. We recommend always having a license file, even if it is not an open source license.

4. main.tf, variables.tf, outputs.tf. These are the recommended filenames for a minimal module, even if they're empty. main.tf should be the primary entrypoint. For a simple module, this may be where all the resources are created. For a complex module, resource creation may be split into multiple files but any nested module calls should be in the main file. variables.tf and outputs.tf should contain the declarations for variables and outputs, respectively.

5. Variables and outputs should have descriptions. All variables and outputs should have one or two sentence descriptions that explain their purpose. This is used for documentation. See the documentation for variable configuration and output configuration for more details.

6. Nested modules. Nested modules should exist under the modules/ subdirectory. Any nested module with a README.md is considered usable by an external user. If a README doesn't exist, it is considered for internal use only. These are purely advisory; Terraform will not actively deny usage of internal modules. Nested modules should be used to split complex behavior into multiple small modules that advanced users can carefully pick and choose. For example, the Consul module has a nested module for creating the Cluster that is separate from the module to setup necessary IAM policies. This allows a user to bring in their own IAM policy choices.

7. Examples. Examples of using the module should exist under the examples/ subdirectory at the root of the repository. Each example may have a README to explain the goal and usage of the example. Examples for submodules should also be placed in the root examples/ directory.

8. Because examples will often be copied into other repositories for customization, any module blocks should have their source set to the address an external caller would use, not to a relative path.