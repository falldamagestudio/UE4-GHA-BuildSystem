
module "ue4-gha-build-agent" {
    source = "../ue4-build-agent"

    name = var.name
    project_id = var.project_id
    zone = var.zone
    image = var.image
    boot_disk_size = var.boot_disk_size

    metadata = {
        github-scope = var.github_scope
        github-pat = var.github_pat
        runner-name = var.runner_name
    }
}