# Tools for the fish slavage facility data

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/dapperstats/salvage/master/LICENSE)
[![Lifecycle:maturing](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

This repository contains code and tools for smooth interactions with the [salvage database](ftp://ftp.dfg.ca.gov/salvage/).

## Docker image

An image based on the [`Dockerfile`](https://github.com/dapperstats/salvage/blob/master/Dockerfile) here is [available on docker hub](https://hub.docker.com/u/dapperstats/salvage). 
Upon building, the resulting container will populate the directory with the most up-to-date version of the salvage `.accdb` database as a set of `.csv` files and open an interactive `R` session for the user within that directory.

More in-depth instructions and explanations will be provided shortly, but in the meantime, to use the image
1. [Install Docker](https://docs.docker.com/install/)
   * This may not be a trivial step, depending on platform/OS, but the linked documentation is very complete and helpful
2. Download the image
   * `sudo docker pull dapperstats/salvage:0.1.0`
3. Run the containter
   * `sudo docker container run -ti --name salvage_0.1.0 dapperstats/salvage:0.1.0`

The script in the [`Dockerfile`](https://github.com/dapperstats/salvage/blob/master/Dockerfile) functionally sets the build environment, downloading the necessary libraries and including the [`scripts/containter_start.bash`](https://github.com/dapperstats/salvage/blob/master/scripts/containter_start.bash) script, which is where all of the specific code to get the data exists.
The code in [`scripts/containter_start.bash`](https://github.com/dapperstats/salvage/blob/master/scripts/containter_start.bash) could be run on its own outside of a container, as long as the dependencies are available.

## Authors and Contributions

**J. L. Simonis** is presently the sole author of the code. 

If you are interested in contributing, see the [Contributor Guidelines](https://github.com/dapperstats/salvage/blob/master/CONTRIBUTING.md) and [Code of Conduct](https://github.com/dapperstats/salvage/blob/master/CODE_OF_CONDUCT.md).
