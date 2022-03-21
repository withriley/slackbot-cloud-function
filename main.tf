resource "google_storage_bucket" "bucket" {
  for_each                    = local.functions
  name                        = each.key
  project                     = var.project
  location                    = var.region
  uniform_bucket_level_access = true
}

resource "google_pubsub_topic" "main" {
  name                       = var.name
  project                    = var.project
  message_retention_duration = "86600s"
}

data "archive_file" "source" {
  for_each    = local.functions
  type        = "zip"
  source_dir  = each.value.path
  output_path = "${each.value.path}.zip"
}

resource "google_storage_bucket_object" "zip" {
  for_each = local.functions
  name     = "${each.key}-${data.archive_file.source[each.key].output_md5}.zip"
  bucket   = google_storage_bucket.bucket[each.key].name
  source   = "${each.value.path}.zip"
}

resource "google_cloudfunctions_function" "function" {
  for_each    = local.functions
  name        = each.key
  description = each.value.description
  runtime     = "python39"
  project     = var.project
  region      = var.region
  environment_variables = merge({
    SLACK_SECRET = google_secret_manager_secret_version.version.secret_data
    TOPIC_ID     = google_pubsub_topic.main.name
    PROJECT_ID   = var.project
    REGION       = var.region
  }, var.environment_variables)

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket[each.key].name
  source_archive_object = google_storage_bucket_object.zip[each.key].name

  dynamic "event_trigger" {
    for_each = each.value.settings ? ["1"] : []
    content {
      event_type = "google.pubsub.topic.publish"
      resource   = google_pubsub_topic.main.id
    }
  }

  trigger_http = each.value.settings ? null : true
  entry_point  = each.key
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  for_each       = local.functions
  project        = google_cloudfunctions_function.function[each.key].project
  region         = google_cloudfunctions_function.function[each.key].region
  cloud_function = google_cloudfunctions_function.function[each.key].name

  role   = "roles/cloudfunctions.invoker"
  member = each.value.member
}

resource "google_project_iam_binding" "project_binding" {
  project = var.project
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${google_cloudfunctions_function.function["${var.name}-slackbot-listener"].service_account_email}"]
}