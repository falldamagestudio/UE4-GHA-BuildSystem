

# One-time setup

## Google Cloud setup

* Create a user and an organization in Google Cloud Platform.
* Set up a billing account for your organization. Provide credit card information.

## GitHub setup, for your company

* Create a GitHub organization for your company.

---

# Setup for each game

## GitHub repository setup

* Fork (if you want it public) or [Import](https://help.github.com/en/github/importing-your-projects-to-github/importing-a-repository-with-github-importer) (if you want it private) this repository to your company's GitHub organization, renaming it to "<your game>-Infrastructure".

### Setup per user

You will likely do this setup once, for the grand game

### GitHub repository setup

* Fork your game's infrastructure repository to your local GitHub user.

## Google Cloud setup

* Create a new project in Google Cloud Platform. Name it according to the GitHub repository that contains the game's infrastructure configuration + suffixed with your username.
* Visit APIs & Services | OAuth consent screen. Set up an Internal screen. [TODO: what name?]
* Enable the Cloud Resource Manager API for your project: https://console.developers.google.com/apis/library/cloudresourcemanager.googleapis.com

* Create a bucket for state storage within the new project. Name it according to the project name, suffixed with `-state`
* Enable versioning for the bucket.

* Create an App Engine application in the project. Create it in the location where you will run the watchdog.

* Add a new Service Account to the project. Grant it the Project Editor role.

## Terraform setup

* Check out your game's infrastructure repository.
* Duplicate `configurations/falldamagestudio/UE4-GHA-Infrastructure` and name the folder `configurations/<org>/<repo>`, according to your git repo name
* Modify `configurations/<org>/<repo>/backend.hcl` to point to the state bucket
* Modify all `configurations/<org>/<repo>/*/terraform.tfvars` files, and ensure that all elements have up-to-date names. Important items:
** `.../project/terraform.tfvars:project_id` - Google Cloud project ID
** `.../project/terraform.tfvars:region` - region where region-bound Google Cloud resources will be created
** `.../project/terraform.tfvars:zone` - zone where zone-bound Google Cloud resources will be created
** `.../storage/terraform.tfvars:terraform_state_bucket` - Same bucket name as given in backend.hcl
** `.../storage/terraform.tfvars:name` - Name of longtail bucket
** `.../builders/terraform.tfvars:terraform_state_bucket` - Same bucket name as given in backend.hcl
** `.../builders/terraform.tfvars:github_scope` - org/repo name for the game project
** `.../builders/terraform.tfvars:machine_type` - build machine type
** `.../builders/terraform.tfvars:boot_disk_size` - boot disk size, measured in GB. Max 2TB.
** `.../watchdog/terraform.tfvars:terraform_state_bucket` - Same bucket name as given in backend.hcl
** `.../watchdog/terraform.tfvars:source_bucket_name` - Name of bucket that will be used for storing cloud function source code
** `.../watchdog/terraform.tfvars:function_name` - Name cloud function
** `.../watchdog/terraform.tfvars:github_organization` - org name for the game project
** `.../watchdog/terraform.tfvars:github_project` - repo name for the game project

* If you are testing locally, add details to
** `.../builders/user.auto.tfvars:github_pat` - Personal Access Token that grants access to the game project
** `.../builders/user.auto.tfvars:image` - VM image name to be used for builders

* If you will let GitHub Actions run deployment, add some secrets to your infrastructure repository:
** `GAME_GITHUB_PAT` - Personal Access Token that grants access to the game project
** `GCP_SERVICE_ACCOUNT_CREDENTIALS` - credentials for the Service Account that any Google Cloud activity is done as

* Commit the changes

## Game project setup

* Add some secrets to your game project:
* `WATCHDOG_TRIGGER_URL` - HTTPS trigger URL for the watchdog Cloud Function; you can find this either via the Google Cloud web UI
* `LONGTAIL_GCLOUD_CREDENTIALS` - credentials for the Service Account that that any Google Cloud activity is done as

## Bring up the infrastructure

* Let GitHub Actions do its thing, or run it yourself:

* `(cd configurations/<org>/<repo>/project && terraform init --backend-config=../backend.hcl && terraform plan && terraform apply)`
* `TF_VAR_image=<image_name>`
* `./scripts/build-packer-image.sh configurations/<org>/<repo>/build-agent-image/vars.json submodules/UE4-GHA-BuildAgent $TF_VAR_image`
* `(cd configurations/<org>/<repo>/storage && terraform init --backend-config=../backend.hcl && terraform plan && terraform apply)`
* `(cd configurations/<org>/<repo>/builders && terraform init --backend-config=../backend.hcl && terraform plan && terraform apply)`
* `(cd configurations/<org>/<repo>/watchdog && terraform init --backend-config=../backend.hcl && terraform plan && terraform apply)`

## Tear down the infrastructure

* `(cd configurations/<org>/<repo>/watchdog && terraform init --backend-config=../backend.hcl && terraform destroy)`
* `(cd configurations/<org>/<repo>/builders && terraform init --backend-config=../backend.hcl && terraform destroy)`
* `(cd configurations/<org>/<repo>/storage && terraform init --backend-config=../backend.hcl && terraform destroy)`
* `(cd configurations/<org>/<repo>/project && terraform init --backend-config=../backend.hcl && terraform destroy)`
