resource "google_secret_manager_secret" "secret" {
  project   = var.project
  secret_id = "${var.name}-slackbot-auth"

  replication {
    automatic = true
  }
  depends_on = [
    google_project_service.project
  ]
}

resource "google_secret_manager_secret_version" "version" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = var.slack_secret
  depends_on = [
    google_project_service.project
  ]
}