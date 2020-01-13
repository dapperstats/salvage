# Tools for the fish salvage facility data 

[![Build Status](https://travis-ci.org/dapperstats/salvage.svg?branch=master)](https://travis-ci.org/dapperstats/salvage)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/dapperstats/salvage/master/LICENSE)
[![Lifecycle:experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

<img src="imgs/hex.png" width="200px" align="right">

Code and tools for smooth interactions with the [California Delta](https://en.wikipedia.org/wiki/Sacramento%E2%80%93San_Joaquin_River_Delta) [fish salvage monitoring database](https://wildlife.ca.gov/Conservation/Delta/Salvage-Monitoring).

## Data Conversion 

The present focus is reliably generating data products that are more broadly accessible. 

To that end, each day, the [`/data` directory](https://github.com/dapperstats/salvage/blob/master/data) is populated with `.csv`s from an up-to-date "current" (1993 - Present) salvage database file (`Salvage_data_FTP.accdb`).

Updates are executed via [`cron` jobs](https://docs.travis-ci.com/user/cron-jobs/) on [`travis-ci`](https://travis-ci.org/dapperstats/salvage).

Read more details on the methods, including how to run your own data conversions, [here](https://github.com/dapperstats/salvage/blob/master/CONVERSION.md).

## Authors

[**J. L. Simonis**](https://orcid.org/0000-0001-9798-0460) of [DAPPER Stats](https://www.dapperstats.com)

If you are interested in contributing, see the [Contributor Guidelines](https://github.com/dapperstats/salvage/blob/master/CONTRIBUTING.md) and [Code of Conduct](https://github.com/dapperstats/salvage/blob/master/CODE_OF_CONDUCT.md).
