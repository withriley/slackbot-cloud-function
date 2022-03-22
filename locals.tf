locals {
  functions = {
    "slackbot_listener" = {
      path        = "${path.module}/functions/slackbot_listener"
      settings    = false
      member      = "allUsers"
      description = "Receive and respond to initial Slack Requests and pass on the command to the Worker Function"
    },
    "${var.name}" = {
      path        = "${var.path}"
      settings    = true
      member      = "serviceAccount:${var.project}@appspot.gserviceaccount.com"
      description = var.description
    }
  }
  apis = [
    "secretmanager.googleapis.com",
    "cloudfunctions.googleapis.com",
    "pubsub.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
}