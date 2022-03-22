resource "google_project_service" "project" {
  for_each = toset(local.apis)
  project  = var.project
  service  = each.value

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services=true
}