# Build UE4 games with GitHub + GitHub Actions + Google Cloud

This is an automated build system that allows you to build UE4 games, with some nifty features:

**It supports incremental builds**. Turnaround time for minimal changes are on the order of minutes.

**It uses 100% cloud-based services and hardware**. There is no need to manage physical machines. You can test what happens to your build times when you move to a 96-vCPU machine easily.

**Build agents are stopped when not in use**. You pay for storage 24/7, but compute is only billed when agents are running.

**You can set up a replica of the build system by forking**. Fork it, do some setup work, and voila! You have a clone of the build system that you can experiment with. Develop in your fork, and send PRs upstream.

See [UE4-GHA-Engine](https://github.com/falldamagestudio/UE4-GHA-Engine) and [UE4-GHA-Game](https://github.com/falldamagestudio/UE4-GHA-Game) for an engine/game combination that uses this to build itself via GitHub Actions.

# Technology

The game and the infrastructure are both kept in GitHub.

GitHub Actions is used as task runner. For the game, this involves fetching UE4, building the game, and uploading the finished game packge. For the infrastructure, this involves setting up storage buckets, creating build agents, and setting up the watchdog service.

UE4 and built game packages are kept in a storage bucket in Google Cloud. Longtail is used for uploading/downloading builds.

Build agents are VMs in Google Cloud. These VMs are started/stopped as needed by the watchdog service.

The watchdog service is a Cloud Function, again running in Google Cloud. It is invoked on-demand by the game's build script, and also every N minutes in case a trigger has been missed.

# Status

This has been used for a year by one game project to produce engine builds. That team is moving to a Jenkins solution to get more build pipeline customizability than GitHub Actions can offer. An indie game project has used it for engine + game builds for a while.

# Cost

The build system for an example game costs an estimated $70/month when idle and $170/month for a tiny development team (see [cost estimation](https://docs.google.com/spreadsheets/d/1DrYU_NA2Wwc8I3487ggpIlFdwStyohGpDkj04EooBAs/edit?usp=sharing)).

Actual data from a team using it, with some configuration tweaks:
* ~£35 for a month
* £0.5 on days with no activity
* Up to £1 for other days
* Engine builds costing ~£3 each.

# How to use

See [OPERATION.md](OPERATION.md) for usage instructions.

See [COMMON_PROBLEMS.md](COMMON_PROBLEMS.md) for some common problems and resolutions.

Make sure to check out the [project issues](https://github.com/falldamagestudio/UE4-GHA-BuildSystem/issues) as well; you might be facing something that is known but without a solution yet.

# Further reading

Here is [a blog post](https://blog.falldamagestudio.com/posts/building-unreal-engine-with-github-actions/) that provides more motivation and background details about the build system.
