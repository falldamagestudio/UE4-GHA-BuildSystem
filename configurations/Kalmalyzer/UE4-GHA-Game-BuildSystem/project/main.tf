module "project" {
  source     = "../../../../submodules/UE4-BuildServices/services/project"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}
