provider "google" {

  version = "~> 3.0"

  project = var.project_id
}

module "project" {
  source = "./project"

  project_name       = var.project_name
  project_id         = var.project_id
  org_id             = var.org_id
  billing_account_id = var.billing_account_id

  //   region = var.region
  //   zone = var.zone
}

module "google_apis" {
  source = "./google_apis"

  // TODO: add a depends_on rule between these once Terraform 0.13 is stable.
  // Terraform 0.13.0-beta1 supports depends_on for modules ( https://github.com/hashicorp/terraform/issues/17101 )
  // ... but sometimes generates crashes when handling multiple modules ( https://github.com/hashicorp/terraform/issues/25114 )
  //
  // depends_on = [ project ]
}

module "iap_brand" {
  source = "./iap_brand"

  // TODO: add a depends_on rule between these once Terraform 0.13 is stable.
  // Terraform 0.13.0-beta1 supports depends_on for modules ( https://github.com/hashicorp/terraform/issues/17101 )
  // ... but sometimes generates crashes when handling multiple modules ( https://github.com/hashicorp/terraform/issues/25114 )
  //
  // depends_on = [ google_apis ]

  support_email     = var.support_email
  application_title = var.application_title
}
