resource "google_project" "this" {
    name = var.project_name
    project_id = var.project_id
    org_id = var.org_id
    billing_account = var.billing_account_id

    # TODO: comment
    skip_delete = true
}
