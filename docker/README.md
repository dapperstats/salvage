#  [salvage.fish](https://www.salvage.fish)

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/dapperstats/salvage/main/LICENSE)
[![Lifecycle:maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3628045.svg)](https://doi.org/10.5281/zenodo.3628045)

Tools for smooth interactions with the [California Delta](https://en.wikipedia.org/wiki/Sacramento%E2%80%93San_Joaquin_River_Delta) [fish salvage monitoring database](https://wildlife.ca.gov/Conservation/Delta/Salvage-Monitoring).

The image is built using the [`Docker` GitHub Action](https://github.com/dapperstats/salvage/actions/workflows/docker-publish.yml) for any pull request in the `salvage` repository but is only pushed to [Docker Hub](https://hub.docker.com/repository/docker/dapperstats/salvage) upon creation of a tagged release.

Two copies of the image are pushed to Docker Hub: one tagged with the release version and one tagged as "latest"..