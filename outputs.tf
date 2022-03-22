output "function_url" {
  value       = google_cloudfunctions_function.function["${var.name}"].https_trigger_url
  description = "The URL that will need to be provided to your Slackbot."
}