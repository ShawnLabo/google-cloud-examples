Quarkus Quickstart
==================

**このプロジェクトは Google Cloud の公式プロジェクトではありません**

## 準備

Cloud Shell 以外の環境では次のものを準備してください。

* [Cloud SDK](https://cloud.google.com/sdk/docs/install-sdk) のインストールと初期化
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) のインストール


## デプロイ手順

### 1. Google Cloud プロジェクトの作成

Google Cloud のプロジェクトを作成してください。

次のコマンドを実行して `PROJECT_ID` 環境変数に作成したプロジェクト ID を設定してください。

```bash
export PROJECT_ID="作成したプロジェクトのID"
```

### 2. Terraform 実行

以下のコマンドで Terraform を実行してください。

```bash
./devops/terraform.sh "${PROJECT_ID}"
```

### 3. Git Push

次のコマンドで SSH 鍵ペアを作成してください。既に鍵ペアが存在する場合はスキップしてください。

```bash
ssh-keygen -t ed25519
```

公開鍵を[こちら](https://source.cloud.google.com/user/ssh_keys?register=true)から Cloud Source Repositories に登録してください。
公開鍵は次のコマンドで表示できます。

```bash
cat ~/.ssh/id_ed25519.pub
```

以下のコマンドでソースコードを Cloud Source Repositories のリポジトリに Push してください。

```bash
git remote add sourcerepo "ssh://$(gcloud config get-value account)@source.developers.google.com:2022/p/${PROJECT_ID}/r/quickstart-quarkus"
git push sourcerepo main
```

以上でデプロイ完了です。
[コンソール](https://console.cloud.google.com/run) で Cloud Run サービスを確認してください。

## Quarkus プロジェクトのセットアップ

次のコマンドで Quarkus プロジェクトを作成できます。

```bash
quarkus create app ARTIFACT-ID \
  --gradle --extension=jib
```

次のコマンドで開発サーバーを起動できます。

```bash
cd ARTIFACT-ID
quarkus dev
```
