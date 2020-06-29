# Build UE4 games with GitHub + GitHub Actions + Google Cloud

This is an automated build system that allows you to build UE4 games, with some nifty features:

**It supports incremental builds**. Turnaround time for minimal changes are on the order of minutes.

**It uses 100% cloud-based services and hardware**. There is no need to manage physical machines. You can test what happens to your build times when you move to a 96-vCPU machine easily.

**Build agents are stopped when not in use**. You pay for storage 24/7, but compute is only billed when agents are running. The build system for an example game costs approximately $1/day when idle.

**You can set up a replica of the build system by forking**. Fork it, do some setup work, and voila! You have a clone of the build system that you can experiment with. Develop in your fork, and send PRs upstream.

# Technology

The game and the infrastructure are both kept in GitHub.

GitHub Actions is used as task runner. For the game, this involves fetching UE4, building the game, and uploading the finished game packge. For the infrastructure, this involves setting up storage buckets, creating build agents, and setting up the watchdog service.

UE4 and built game packages are kept in a storage bucket in Google Cloud. Longtail is used for uploading/downloading builds.

Build agents are VMs in Google Cloud. These VMs are started/stopped as needed by the watchdog service.

The watchdog service is a Cloud Function, again running in Google Cloud. It is invoked on-demand by the game's build script, and also every N minutes in case a trigger has been missed.

# Status

This is a proof-of-concept. It works, but hasn't been used by a team that is actively building a game. See the project issues to get a feeling for what is missing.

# How to use

See [OPERATION.md](Operation.md) for usage instructions.