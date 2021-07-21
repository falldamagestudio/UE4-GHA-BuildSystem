## Hitting resource quota limits in Google Cloud Platform

If you are getting error messages such as these during build system bring-up (when running Terraform), then
you are hitting [resource quota limits](https://cloud.google.com/compute/quotas) in Google Cloud Platform (GCP):

```
Error: Error waiting for instance to create: Quota 'CPUS' exceeded.  Limit: 29.0 in region europe-west3.


  on ../../../../submodules/UE4-BuildServices/services/builders/ue4_build_agent/main.tf line 1, in resource "google_compute_instance" "default":
   1: resource "google_compute_instance" "default" ***



Error: Error waiting for instance to create: Quota 'CPUS_ALL_REGIONS' exceeded.  Limit: 32.0 globally.


  on ../../../../submodules/UE4-BuildServices/services/builders/ue4_build_agent/main.tf line 1, in resource "google_compute_instance" "default":
   1: resource "google_compute_instance" "default" ***


Error: Terraform exited with code 1.
Error: Process completed with exit code 1.
```

In the above example, the user has a limit of max 29 vCPUs used in one specific region, and a max of 32 vCPUs used across all the regions in the GCP project.

The user can reduce the number of vCPUs used by the build machines - for example, changing machine type settings in `terraform.tfvars` so that the engine builder is of `n1-standard-16` type and the game builder is of `n1-standard-8` type, thereby using 24 vCPUs in total and staying below the quota limits.

The user can also visit [the Quotas page in the GCP Console](https://console.cloud.google.com/iam-admin/quotas) and request raised limits for the important quotas. Limit requests are typically processed within 24-48 hours.

## LFS content in the game repositoy is not being checked out

The example engine/game repos do not include any LFS content. If your game project has LFS content, then you need to modify the build steps within the game repository to also check out the LFS content:

```
     - name: Check out repository
        uses: actions/checkout@v2
        with:
          clean: false
          lfs: true

      - name: Checkout LFS objects
        run: git lfs checkout

```

## Users encounter VS2910 version mismatches when building game locally

The build agent will install and use the latest version of VS2019 that is available at the time that the VM image is created. That VS2019 version will be used when creating pre-built Engine versions.

If users attempt to use that pre-built Engine version on a machine that has an older VS2019 version, they are likely to encounter compile/link errors. The easiest way around this is to ensure that users update to the latest VS2019 version.

It should also be possible to use older VS2019 versions in the build agents - but that has not yet been implemented.

## Self-hosted runners disappear after long periods of inactivity

GitHub Actions will automatically 'forget' any self-hosted runner that hasn't connected to the backend in 30 days. Once GHA has forget the runners for a particular label, builds that need runners for that label will fail immediately.

To get around this, start your runners manually after they have disappeared.

Also see #15.

