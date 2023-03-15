/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_sourcerepo_repository" "repo" {
  name = "quickstart-quarkus"

  depends_on = [google_project_service.sourcerepo]
}

resource "google_sourcerepo_repository_iam_member" "source_reader-to-cloudbuild" {
  repository = google_sourcerepo_repository.repo.name
  role       = "roles/source.reader"
  member     = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"

  depends_on = [google_project_service.cloudbuild]
}

resource "google_cloudbuild_trigger" "trigger" {
  name     = "quickstart-quarkus"
  filename = "cloudbuild.yaml"

  trigger_template {
    repo_name   = google_sourcerepo_repository.repo.name
    branch_name = "main"
  }

  depends_on = [google_project_service.cloudbuild]
}

resource "google_artifact_registry_repository" "repo" {
  provider = google-beta

  location      = "asia-northeast1"
  repository_id = "quickstart-quarkus"
  format        = "DOCKER"

  depends_on = [google_project_service.artifactregistry]
}

resource "google_artifact_registry_repository_iam_member" "artifactregistry_writer-to-cloudbuild" {
  provider = google-beta

  location   = google_artifact_registry_repository.repo.location
  repository = google_artifact_registry_repository.repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"

  depends_on = [google_project_service.cloudbuild]
}

resource "google_artifact_registry_repository_iam_member" "artifactregistry_reader-to-app" {
  provider = google-beta

  location   = google_artifact_registry_repository.repo.location
  repository = google_artifact_registry_repository.repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.app.email}"
}

resource "google_cloud_run_service_iam_member" "run_developer-to-cloudbuild" {
  location = google_cloud_run_service.app.location
  service  = google_cloud_run_service.app.name
  role     = "roles/run.developer"
  member   = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"

  depends_on = [google_project_service.cloudbuild]
}

resource "google_service_account_iam_member" "iam_serviceAccountUser-to-cloudbuild" {
  service_account_id = google_service_account.app.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"

  depends_on = [google_project_service.cloudbuild]
}
