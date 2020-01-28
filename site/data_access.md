---
title: "Data Access"
---

<br>

This document outlines the process by which the remote database is converted into local files and data objects.

<br>

## `bash` script: remote `.accdb` to local `.csv`s 

The main conversion is from the `.accdb` file on the remote [ftp](ftp://ftp.dfg.ca.gov/salvage/) to a local set of `.csv` files named by the tables in the database. 
We accomplish this through a stable [`Docker`](https://www.docker.com) [software container](https://www.docker.com/resources/what-container).
The [`accessor` image](https://hub.docker.com/r/dapperstats/accessor) is freely available on [Docker Hub](https://hub.docker.com/) and its default setting are configured for the contemporary salvage database.
Code for the construction of the `accessor` image is available in a [separate repo](https://www.github.com/dapperstats/accessor).

For ease, we provide a [daily-made version of the salvage data](https://github.com/dapperstats/salvage/blob/master/data) with `.csv`s from an up-to-date "current" (1993 - Present) salvage database file (`Salvage_data_FTP.accdb`).
Updates are pushed to GitHub as [tagged Releases](https://github.com/dapperstats/salvage/releases).
Data can be downloaded via via various methods from the repository.
Updates are executed via [`cron` jobs](https://docs.travis-ci.com/user/cron-jobs/) on [`travis-ci`](https://travis-ci.org/dapperstats/salvage).


To use the current image to generate an up-to-date container with data for yourself
1. (If needed) [install Docker](https://docs.docker.com/get-docker/)
   * Specific instructions vary depending on OS
2. Open up a docker-ready terminal
3. Download the image
   * `sudo docker pull dapperstats/salvage`
4. Build the container
   * `sudo docker container run -ti --name salvage dapperstats/salvage`
5. Copy the data out from the container 
   * `sudo docker cp salvage:/data .`

<br>

## `R` script: local `.csv`s to `R` `list` object 

An additional conversion makes the data available in [`R`](https://www.r-project.org/) as a `list` of `data.frames` that is directly analagous to the `.accdb` database of tables.

Within an instance of `R`, navigate to where you have this code repository located, source the functions script, and read in the database:
```
source("scripts/r_functions.R")
database <- read_database()
```
The resulting `database` object is a named `list` of the database's tables, ready for analyses.

