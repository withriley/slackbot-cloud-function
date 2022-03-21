locals {
  functions = {
    "${var.name}-slackbot-listener" = {
      path        = "${path.module}/functions/slackbot-listener"
      settings    = false
      member      = "allUsers"
      description = "Receive and respond to initial Slack Requests and pass on the command to the Worker Function"
    },
    "${var.name}" = {
      path        = "${path.module}/var.path"
      settings    = true
      member      = "serviceAccount:${var.project}@appspot.gserviceaccount.com"
      description = var.description
    }
  }
}