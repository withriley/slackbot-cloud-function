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