

# One-time setup

## Google Cloud setup

* Create a user and an organization in Google Cloud Platform.
* Set up a billing account for your organization. Provide credit card information.

## Terraform Cloud setup, for your company

* Create an email account for Terraform Cloud automation.
* Create a GitHub account for Terraform Cloud automation. Link it to the email account that you created.

* Create a GitHub organization for your company.
* While logged in as the GitHub account for Terraform Cloud automation, on GitHub, visit the Application settings for the Terraform Cloud OAuth application. Request for the application to be able to access your GitHub organization. Accept the request (someone will receive an email about this).

* Create a personal Terraform Cloud account.
* Create an organization for your company in Terraform Cloud.
* Add a VCS provider to your company's organization in Terraform Cloud. Connect it to GitHub, via the Terraform Cloud automation account.

## Terraform Cloud setup, for yourself

* Create an organization for your personal use in Terraform Cloud. (Name it after your GitHub user name, if that is available)
* Add a VCS provider to your personal organization in Terraform Cloud. Connect it to GitHub, via your personal GitHub account.

* Create a Terraform Cloud API token for yourself

---

# Setup for each game

## GitHub repository setup

* Fork (if you want it public) or [Import](https://help.github.com/en/github/importing-your-projects-to-github/importing-a-repository-with-github-importer) (if you want it private) this repository to your company's GitHub organization, renaming it to "<your game>-Infrastructure".
* Invite the Terraform Cloud automation account to your company's version of this GitHub repository. Give the invite "Admin" rights.

### Setup per user

You will likely do this setup once, for the grand game

### GitHub repository setup

* Fork your game's infrastructure repository to your local GitHub user.

## Google Cloud setup

* Create a new project in Google Cloud Platform. Name it according to the GitHub repository that contains the game's infrastructure configuration + suffixed with your username.
* Visit APIs & Services | OAuth consent screen. Set up an Internal screen. [TODO: what name?]
* Enable the Cloud Resource Manager API for your project: https://console.developers.google.com/apis/library/cloudresourcemanager.googleapis.com

## Create build agent image

* Check out the [UE4-GHA-BuildAgent](https://github.com/falldamagestudio.com/UE4-GHA-BuildAgent) repository.
* Build a VM image, targetting the current 

## Terraform setup

* Check out your game's infrastructure repository.
* Install terraform-config-inspect by running `go get github.com/kiranjthomas/terraform-config-inspect`
* Enter the `environment` folder and run `powershell .\New-TFVarsFiles.ps1 -TerraformOrganization <your Terraform Cloud organization name> -GitHubRepository <your GitHub repository name>`. This will create a terraform.tfvars file
  in each of `environment/project`, `environment/storage` and `environment/builders`.
* Edit the `**/terraform.tfvars` files, and ensure that all elements have up-to-date names. Important items:
** `environment/project/terraform.tfvars:project_id` - Google Cloud project ID
** `environment/project/terraform.tfvars:region` - region where region-bound Google Cloud resources will be created
** `environment/project/terraform.tfvars:zone` - zone where zone-bound Google Cloud resources will be created
** `environment/storage/terraform.tfvars:name` - name of the Google Cloud Storage bucket that will hold all build results
** `environment/builders/terraform.tfvars:github_scope` - org/repo name for the game project
** `environment/builders/terraform.tfvars:github_pat` - Personal Access Token that grants access to the game project
** `environment/builders/terraform.tfvars:image` - name of the build agent's VM image
** `environment/builders/terraform.tfvars:machine_type` - build machine type
** `environment/builders/terraform.tfvars:boot_disk_size` - boot disk size, measured in GB. Max 2TB.
* Run `powershell .\New-Workspaces.ps1 -TerraformOrganization <your Terraform Cloud organization name> -TerraformAuthToken <API Token> -VCSProvider <Name of your VCS Provider> -GitHubOrganization <GitHub organization name> -GitHubRepository <GitHub repository name>`. This will create workspaces within Terraform Cloud.

## Bring up the infrastructure

* Visit the Terraform Cloud console. Plan & apply the workspaces in the following order:
** Project
** Storage
** Builders

## Tear down the infrastructure

* Visit the Terraform Cloud console. Queue for destruction (plan & apply) in the following order:
** Builders
** Storage
** Project

* Delete each of the workspaces
