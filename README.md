# Infrastructure control script for UE4 + GitHub Actions-based build system

This provides automation for managing a Github Actions-based build system for an UE4 game.

This brings self-hosted runners to the GitHub Actions repository. The runners are VMs rented from Google Cloud. Build artifacts are kept in Google Cloud Storage buckets. The VM(s) and storage bucket(s) are managed via Terraform Cloud.

# How to use

See [OPERATION.md](Operation.md) for usage instructions.