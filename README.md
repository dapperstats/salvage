# [salvage.fish](https://www.salvage.fish)

[![Build Status](https://travis-ci.org/dapperstats/salvage.svg?branch=master)](https://travis-ci.org/dapperstats/salvage)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/dapperstats/salvage/master/LICENSE)
[![Lifecycle:maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3628045.svg)](https://doi.org/10.5281/zenodo.3628045)
[![Netlify Status](https://api.netlify.com/api/v1/badges/d4013762-bc67-40c7-a656-fd24e92dd06e/deploy-status)](https://app.netlify.com/sites/peaceful-jepsen-15c633/deploys)

<img src="imgs/hex.png" width="200px" align="right">

Tools for smooth interactions with the [California Delta](https://en.wikipedia.org/wiki/Sacramento%E2%80%93San_Joaquin_River_Delta) [fish salvage monitoring database](https://wildlife.ca.gov/Conservation/Delta/Salvage-Monitoring).

## Data Accessability  

One present focus is reliably generating data products that are more broadly accessible. 

Each day, the [`/data` directory](https://github.com/dapperstats/salvage/blob/master/data) is populated with `.csv`s from an up-to-date "current" (1993 - Present) salvage database file (`Salvage_data_FTP.accdb`).

Updates are executed via [`cron` jobs](https://docs.travis-ci.com/user/cron-jobs/) on [`travis-ci`](https://travis-ci.org/dapperstats/salvage) using the `accessor` [`Docker`](https://www.docker.com) [software container](https://www.docker.com/resources/what-container).
Code for the construction of the [`accessor` image](https://hub.docker.com/r/dapperstats/accessor) is available in a [separate repo](https://www.github.com/dapperstats/accessor).
 
Read more details on the [methods](https://github.com/dapperstats/salvage/blob/master/documents/methods.md), including how to run your own data [conversions](https://github.com/dapperstats/salvage/blob/master/documents/conversion.md).

## Authors

[**J. L. Simonis**](https://orcid.org/0000-0001-9798-0460) of [DAPPER Stats](https://www.dapperstats.com)

If you are interested in contributing, see the [Contributor Guidelines](https://github.com/dapperstats/salvage/blob/master/CONTRIBUTING.md) and [Code of Conduct](https://github.com/dapperstats/salvage/blob/master/CODE_OF_CONDUCT.md).
