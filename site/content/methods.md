---
title: "Salvage Data Methods"
date: "2020-01-25"
---

## [Data Access](/data_access)

Accessing the remote data, converting the `.accdb` to `.csv` files, and loading the data into R.
Leverages [the `accessor` software](https://www.github.com/dapperstats/accessor). 

## [Data Preparation](/data_preparation)

Preparing the raw data for summaries and analyses.
Uses included [R script](https://github.com/dapperstats/salvage/blob/master/scripts/salvage_script.R) and [`accessor` R scripts](https://github.com/dapperstats/accessor/blob/master/scripts/r_functions.R) within a [Docker](https://www.docker.com/) container started from the [`accessor` image](https://hub.docker.com/r/dapperstats/accessor)

## Auto-build

The data and output are updated daily via [`cron` jobs](https://docs.travis-ci.com/user/cron-jobs/) on [`travis-ci`](https://travis-ci.org/dapperstats/salvage).

