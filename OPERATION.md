

# One-time setup

## Google Cloud setup

* Create a user and an organization in Google Cloud Platform.
* Set up a billing account for your organization. Provide credit card information.

## GitHub setup

* Create a GitHub organization for your company.

# Setup for each game / user

You will need to do these steps once for the game, and once for each user that is going to work on the build system.

## Google Cloud setup

* Create a new project in Google Cloud Platform (GCP). Name it according to the GitHub organization+repository that contains the game's infrastructure configuration + suffixed with your username.
* Visit APIs & Services | OAuth consent screen. Set up an Internal screen. Name it after the GCP project.
* Enable the Cloud Resource Manager API for your project: https://console.developers.google.com/apis/library/cloudresourcemanager.googleapis.com

* Create a bucket for state storage within the new project. Name it as `<GCP project>-state`. Place it in the same region that you intend to have other resources. Choose Standard default storage class. Choose Uniform access control.
* [Enable versioning](https://cloud.google.com/storage/docs/using-object-versioning) for the bucket.

* Create an App Engine application in the project. Create it in the location where you will run the watchdog.

* Add a new Service Account to the project. Name it `GitHub Actions Build System`. Grant it the Project Owner role.
* Create a key for the service account, in JSON format. Hold on to it for the GitHub setup step.

## GitHub setup

First, make sure you have created a repository & GitHub user for your organization if you haven't done so already:

* Fork (if you want it public) or [Import](https://help.github.com/en/github/importing-your-projects-to-github/importing-a-repository-with-github-importer) (if you want it private) this repository to your company's GitHub organization, renaming it to `<org>/<your game>-BuildSystem`. Repeat the process for [https://github.com/falldamagestudio/UE4-GHA-Engine](UE4-GHA-Engine) and [https://github.com/falldamagestudio/UE4-GHA-Game](UE4-GHA-Game).

* Ensure you have a fork/import of Unreal Engine.

* Create a new GitHub account. GitHub Actions will use this account on behalf of your organization. Name it something like `<org>-<your game>-buildsystem`. Give it admin access to your Unreal Engine repository, `<org>/<your game>-Engine` and `<org>/<your game>-Game`.

* Create a Personal Access Token for the GitHub Account (either build system account or your personal account), with name `Access Token for GitHub Actions in <org>/<your game>` and scopes `admin:repo_hook`, `repo`, `workflow`.

## BuildSystem GitHub repo setup

* Locate the key that you created for the `GitHub Actions Build System` service account. Add a new secret to the `<org>/<your game>-BuildSystem` GitHub repository, with name `GCP_SERVICE_ACCOUNT_CREDENTIALS` and the contents of the key file as its value.

* Add a new secret to the `<org>/<your game>-BuildSystem` GitHub repository, with name `ENGINE_AND_GAME_GITHUB_PAT` and the Personal Access Token string named `Access Token for GitHub Actions in <org>/<your game>` as its value.

* Check out the `<org>/<your game>-BuildSystem` repository.
* Duplicate `configurations/falldamagestudio/UE4-GHA-Game-BuildSystem` and name the folder `configurations/<org>/<repo>/<your game>-BuildSystem`, according to your git repo name
* Modify `configurations/<org>/<repo>/<your game>-BuildSystem/backend.hcl` to point to the state bucket
* Modify `configurations/<org>/<repo>/<your game>-BuildSystem/*/terraform.tfvars` files, and ensure that all elements have up-to-date names; see the corresponding `variables.tf` files for details
* Modify `configurations/<org>/<repo>/<your game>-BuildSystem/build-agent-image/vars.json` to point to the appropriate Google Cloud project

* Commit & push the changes. GitHub Actions will bring up the infrastructure.

## Engine GitHub repo setup

* Add some secrets to your engine repository:
* `ENGINE_GITHUB_PAT` - the GitHub Personal Access token that you have created
* `WATCHDOG_TRIGGER_URL` - HTTPS trigger URL for the watchdog Cloud Function; you can find this either via the Google Cloud web UI, or via doing `terraform show` on the `services` project
* `GCP_ENGINE_BUILD_AGENT_CREDENTIALS` - credentials for the `engine-build-agent@...` Service Account (you will need to create these manually via the GCP Cloud Console first)
* `ENGINE_STORAGE_BUCKET_NAME` - the value of `engine_storage_bucket_name` from `terraform.tfvars`

* Check out the `<org>/<your game>-Engine` repository.
* Change the `UE4` submodule to point to a suitable commit within your own Unreal Engine repository.
* Commit & push the changes. GitHub Actions will build an engine version for you.

* View the workflow run in GitHub Actions, and note down the identifier used when uploading the engine build; it will be on the format `engine-<SHA1>-win64`. You will need to update the game repo to refer to this.

## Game GitHub repo setup

* Add some secrets to your game repository:
* `WATCHDOG_TRIGGER_URL` - HTTPS trigger URL for the watchdog Cloud Function; you can find this either via the Google Cloud web UI, or via doing `terraform show` on the `services` project
* `GCP_GAME_BUILD_AGENT_CREDENTIALS` - credentials for `game-build-agent@...` Service Account (you will need to create these manually via the GCP Cloud Console first)
* `ENGINE_STORAGE_BUCKET_NAME` - the value of `engine_storage_bucket_name` from `terraform.tfvars`
* `GAME_STORAGE_BUCKET_NAME` - the value of `game_storage_bucket_name` from `terraform.tfvars`

* Check out the `<org>/<your game>-Game` repository.
* Change `UpdateUE4/desired_version.json` to refer to the recently-built UE4 version.
* Commit & push the changes. GitHub Actions will build a game for you.

# Daily usage

## Update the game

* Push new commits to `<org>/<your game>-Game`. These will be built automatically.

## Update the engine

* Push new commits to your Unreal Engine repository.
* Change the submodule reference in `<org>/<your game>-Engine`.
* Wait for the new engine version to build.
* Update `UpdateUE4/desired_version.json` within `<org>/<your game>-Game`.
* Wait for the game to build.

# Developing on the build system

You can get a personal, full replica of the entire build system. This allows you to test out build system changes in a safe environment before you roll them out for your entire team. To make this happen, you need to fork `<org>/<your game>-BuildSystem`, `<org>/<your game>-Engine` and `<org>/<your game>-Game`. Create a new Google Cloud project. Use your personal account instead of the GitHub service account that was created for your organization. Duplicate the configuration within `<org>/<your game>-BuildSystem/configurations`.

You will need to go through most of the above one-time setup steps, but for your personal forks.

## Bring up the infrastructure from command line

You can perform the terraform operations from your local machine. Since the Terraform state is kept in a GCS bucket, this will not cause conflicts.

* A few details need to be set in a local (ignored by Git) file, namely `.../services/user.auto.tfvars`:
** `github_pat` - Personal Access Token that grants access to the engine, game and UE4 GitHub repositories
** `engine_builder_image` - VM image name to be used for engine builders
** `game_builder_image` - VM image name to be used for game builders

* `(cd configurations/<org>/<repo>/project && terraform init --backend-config=../backend.hcl && terraform plan && terraform apply)`
* `TF_VAR_image=<image_name>`
* `./submodules/UE4-BuildServices/scripts/build-packer-image.sh submodules/UE4-GHA-BuildAgent/UE4-GCE-Win64-Git-GitHubActions-MSVC.json configurations/<org>/<repo>/build-agent-image/vars.json $TF_VAR_image`
* `(cd configurations/<org>/<repo>/services && terraform init --backend-config=../backend.hcl && terraform plan && terraform apply)`

## Tear down the infrastructure from command line

You can use Terraform locally:

* `(cd configurations/<org>/<repo>/services && terraform init --backend-config=../backend.hcl && terraform destroy)`
* `gcloud compute images delete <image names beginning with build-agent-*>`
* `(cd configurations/<org>/<repo>/project && terraform init --backend-config=../backend.hcl && terraform destroy)`

## Tear down the infrastructure via UI

* Run the "Destroy infrastructure" workflow via Github Actions
* Remove any lingering images in the project via Google Cloud's web GUI
