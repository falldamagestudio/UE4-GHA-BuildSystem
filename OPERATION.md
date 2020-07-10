

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


## GitHub repository setup

First, make sure you have created a repository & GitHub user for your organization if you haven't done so already:

* Fork (if you want it public) or [Import](https://help.github.com/en/github/importing-your-projects-to-github/importing-a-repository-with-github-importer) (if you want it private) this repository to your company's GitHub organization, renaming it to `<org>/<your game>-BuildSystem`.

* Create a new GitHub account. GitHub Actions will use this account on behalf of your organization. Name it something like `<org>-<your game>-buildsystem`. Give it read-only access to `<org>/<your game>`.

Then, if you are going to work on the build system yourself:

* Fork the `<org>/<your game>-BuildSystem` repository to your local GitHub user.

Either way, it is time to do some configuration of the repository:

* Locate the key that you created for the `GitHub Actions Build System` account. Add a new secret to the GitHub repository, with name `GCP_SERVICE_ACCOUNT_CREDENTIALS` and the contents of the key file as its value.

* Create a Personal Access Token for the GitHub Account (either build system account or your personal account), with name `Access Token for GitHub Actions in <org>/<your game>` and scopes `admin:repo_hook`, `repo`, `workflow`. Add a new secret to the GitHub repository, with name `GAME_GITHUB_PAT` and the Personal Access Token string as its value.

## Terraform setup

* Check out the `<your game>-BuildSystem` repository.
* Duplicate `configurations/falldamagestudio/UE4-GHA-Game-BuildSystem` and name the folder `configurations/<org>/<repo>/<your game>-BuildSystem`, according to your git repo name
* Modify `configurations/<org>/<repo>/<your game>-BuildSystem/backend.hcl` to point to the state bucket
* Modify `configurations/<org>/<repo>/<your game>-BuildSystem/*/terraform.tfvars` files, and ensure that all elements have up-to-date names; see the corresponding `variables.tf` files for details
* Modify `configurations/<org>/<repo>/<your game>-BuildSystem/build-agent-image/vars.json` to point to the appropriate Google Cloud project

* Commit & push the changes. GitHub Actions will bring up the infrastructure.

## Engine GitHub repo setup

* Add some secrets to your engine repository:
* `ENGINE_GITHUB_PAT` - the GitHub Personal Access token that will be used to access the Engine + the UE4 repo
* `WATCHDOG_TRIGGER_URL` - HTTPS trigger URL for the watchdog Cloud Function; you can find this either via the Google Cloud web UI, or via doing `terraform show` on the `services` project
* `GCP_ENGINE_BUILD_AGENT_CREDENTIALS` - credentials for the `engine-build-agent@...` Service Account (you will create these manually via the GCP Cloud Console)

## Game GitHub repo setup

* Add some secrets to your game repository:
* `WATCHDOG_TRIGGER_URL` - HTTPS trigger URL for the watchdog Cloud Function; you can find this either via the Google Cloud web UI, or via doing `terraform show` on the `services` project
* `GCP_GAME_BUILD_AGENT_CREDENTIALS` - credentials for `game-build-agent@...` Service Account (you will create these manually via the GCP Cloud Console)

## Bring up the infrastructure manually

* A few details need to be set in a local (ignored by Git) file, namely `.../services/user.auto.tfvars`:
** `github_pat` - Personal Access Token that grants access to the engine, game and UE4 GitHub repositories
** `engine_builder_image` - VM image name to be used for engine builders
** `game_builder_image` - VM image name to be used for engine builders

* `(cd configurations/<org>/<repo>/project && terraform init --backend-config=../backend.hcl && terraform plan && terraform apply)`
* `TF_VAR_image=<image_name>`
* `./submodules/UE4-BuildServices/scripts/build-packer-image.sh submodules/UE4-GHA-BuildAgent/UE4-GCE-Win64-Git-GitHubActions-MSVC.json configurations/<org>/<repo>/build-agent-image/vars.json $TF_VAR_image`
* `(cd configurations/<org>/<repo>/services && terraform init --backend-config=../backend.hcl && terraform plan && terraform apply)`

## Tear down the infrastructure manually

* `(cd configurations/<org>/<repo>/engine-services && terraform init --backend-config=../backend.hcl && terraform destroy)`
* `gcloud compute images delete <image names beginning with build-agent-*>`
* `(cd configurations/<org>/<repo>/project && terraform init --backend-config=../backend.hcl && terraform destroy)`
