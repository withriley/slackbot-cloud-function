```bash
gcloud functions deploy resize_gke \
--runtime python39 \
--trigger-http \
--project bc-nonprod-quantexa \
--set-env-vars "SLACK_SECRET=" \
--allow-unauthenticated \
--region australia-southeast1
```