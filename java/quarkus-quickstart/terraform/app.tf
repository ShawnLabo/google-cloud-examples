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

resource "google_service_account" "app" {
  account_id = "quickstart-quarkus"
}

/* ネットワークまわりを設定するために適当なイメージでサービスを作成する */
resource "google_cloud_run_service" "app" {
  name     = "quickstart-quarkus"
  location = "asia-northeast1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
      service_account_name = google_service_account.app.email
    }
  }

  depends_on = [google_project_service.run]
}

resource "google_cloud_run_service_iam_member" "run_invoker-to-allUsers" {
  location = google_cloud_run_service.app.location
  service  = google_cloud_run_service.app.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
