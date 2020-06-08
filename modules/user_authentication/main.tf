resource "google_iap_brand" "this" {
    support_email = var.support_email
    application_title = var.application_title
}

resource "google_iap_client" "this" {
    display_name = "FetchPrebuiltUE4"
    brand = google_iap_brand.this.name
}