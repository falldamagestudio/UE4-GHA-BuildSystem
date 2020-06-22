module "project" {
  source     = "../../../../services/project"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}
