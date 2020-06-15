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
}

module "iap_brand_google_api" {
  source = "./iap_brand_google_api"

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
  // depends_on = [ iap_brand_google_api ]

  support_email     = var.support_email
  application_title = var.application_title
}
