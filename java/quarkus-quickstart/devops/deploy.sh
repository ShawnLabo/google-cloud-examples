#!/usr/bin/env bash
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Usage:
#
#   ./deploy.sh PROJECT_ID [IMAGE_TAG]
#
# コンテナイメージを Cloud Run にデプロイする

project_id=${1:-local}
tag=${2:-$(git rev-parse HEAD)}

image="asia-northeast1-docker.pkg.dev/${project_id}/quickstart-quarkus/app:${tag}"
service_account="quickstart-quarkus@${project_id}.iam.gserviceaccount.com"

gcloud run deploy quickstart-quarkus \
  --image "${image}" \
  --region asia-northeast1 \
  --service-account "${service_account}"
