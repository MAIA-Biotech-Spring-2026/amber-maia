terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Cloud Storage bucket for artifacts
resource "google_storage_bucket" "artifacts" {
  name          = "${var.project_id}-amber-artifacts"
  location      = var.region
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

# Cloud SQL PostgreSQL instance
resource "google_sql_database_instance" "postgres" {
  name             = "amber-postgres"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro" # Change to db-custom-2-7680 for production

    backup_configuration {
      enabled = true
    }

    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        value = "0.0.0.0/0" # Restrict in production
      }
    }
  }

  deletion_protection = false # Set to true in production
}

# Database
resource "google_sql_database" "amber_db" {
  name     = "amber"
  instance = google_sql_database_instance.postgres.name
}

# Cloud Run service for the app
resource "google_cloud_run_service" "app" {
  name     = "amber-app-service"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.cloud_run.email
      containers {
        image = "gcr.io/${var.project_id}/amber-app:latest"

        ports {
          container_port = 8080
        }

        env {
          name  = "PORT"
          value = "8080"
        }

        env {
          name  = "DATABASE_URL"
          value = "postgres://${google_sql_user.app.name}:${google_sql_user.app.password}@/${google_sql_database.amber_db.name}?host=/cloudsql/${google_sql_database_instance.postgres.connection_name}"
        }

        env {
          name  = "STORAGE_BUCKET"
          value = google_storage_bucket.artifacts.name
        }

        env {
          name = "GOOGLE_CLOUD_PROJECT"
          value = var.project_id
        }

        resources {
          limits = {
            cpu    = "1000m"
            memory = "512Mi"
          }
        }
      }

      container_concurrency = 80
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "10"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.postgres.connection_name
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Service account for Cloud Run
resource "google_service_account" "cloud_run" {
  account_id   = "amber-cloud-run"
  display_name = "Amber Cloud Run Service Account"
}

# Grant Cloud Run service account access to Cloud SQL
resource "google_project_iam_member" "cloud_run_sql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Grant Cloud Run service account access to Cloud Storage
resource "google_project_iam_member" "cloud_run_storage" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Grant Cloud Run service account access to Secret Manager
resource "google_project_iam_member" "cloud_run_secrets" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

# IAM policy for Cloud Run (public access)
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.app.name
  location = google_cloud_run_service.app.location
  role     = "roles/run.invoker"
  member   = "allUsers" # Restrict in production
}

# SQL user for the app
resource "google_sql_user" "app" {
  name     = "amber_app"
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}

# Secret Manager for sensitive config
resource "google_secret_manager_secret" "db_password" {
  secret_id = "amber-db-password"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.db_password
}

# Outputs moved to outputs.tf

