data "google_project" "project" {
}

/*
GCP Cloud Run
*/

# create a GCP Cloud Run deployment for the API
resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.cloudrun_image
        resources {
          limits = {
            cpu    = "2.0"
            memory = "8000Mi"
          }
        }
        env {
          name  = "NEXT_PUBLIC_HOST"
          value = var.next_public_host
        }
        ports {
          container_port = 3000
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "30"
        "run.googleapis.com/client-name"   = "terraform"
      }
    }
  }
  autogenerate_revision_name = true
}

# create a GCP IAM Policy that allow all users to invoke Cloud Run instances, making the App publicly available
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

# assign the GCP IAM Policy to the Cloud Run App deplyment
resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}