variable "project" {
  description = "The project you wish to deploy the Slackbot Functions in"
  type        = string
}

variable "region" {
  description = "The region the Slackbots will be deployed into"
  type        = string
}

variable "name" {
  description = "The name of your function"
  type        = string
}

variable "path" {
  description = "The path of your function"
  type        = string
}

variable "description" {
  description = "The description of your function"
  type        = string
}

variable "slack_secret" {
  description = "The Slack API secret that you will be deploying - will be wrapped into a Google Secret and deployed"
  type        = string
}

variable "environment_variables" {
  description = "Any additional environment variables you want inside the Slackbot Functions"
  type        = map(any)
  default     = {}
}