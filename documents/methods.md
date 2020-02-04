---
title: "Salvage Data Methods"
date: "2020-02-01"
author: "Juniper L. Simonis"
---

Here, we describe the methods used to analyze the [California Delta](https://en.wikipedia.org/wiki/Sacramento%E2%80%93San_Joaquin_River_Delta) [fish salvage database](https://wildlife.ca.gov/Conservation/Delta/Salvage-Monitoring), both within an automated pipeline and locally. 

As developed below, the overall computational workflow is depecited in the [`.travis.yml`](https://github.com/dapperstats/salvage/blob/master/.travis.yml) file, which shows a remote implementation.

# Software and Systems

To promote cross-platform availability and future reliability, we leverage a [software container approach](https://www.docker.com/resources/what-container) via [`Docker`](https://www.docker.com), which allows any user to establish stable runtime environments for data retrieval and calculation.
[A container is an instance of a software environment spun-up from an image that has been defined by a `Dockerfile`](https://docs.docker.com/engine/docker-overview/).


## Continuous Deployment

For continuous integration and analysis of newly posted data and continuous deployment of the data products and website, we follow the general approach of White et al. (2019). 
We host our code and data on [GitHub](https://github.com), use [Travis CI](https://travis-ci.org) to orchestrate compute, establish software environments using [Docker](https://www.docker.com) containers, run analysis and related code in [`R`](https://www.r-project.org/), deploy our website via [Netlify](https://www.netlify.com/), and archive everything on [Zenodo](https://www.netlify.com/).

The data and output are updated daily via [`cron` jobs](https://docs.travis-ci.com/user/cron-jobs/) on [`travis-ci`](https://travis-ci.org/dapperstats/salvage) with a recipe (a.k.a. job lifecycle) described by the [`.travis.yml` file](https://github.com/dapperstats/salvage/blob/master/.travis.yml).
Following a successful `cron` run, the updated files and an associated release (tagged with a date-time stamp) are pushed to the master branch in the [GitHub repository](https://github.com/dapperstats/salvage) via the `update_github.bash` script.


## Runtime Environments

### Travis

We use a standard implementation of the `bash` runtime environment on [Travis CI](https://travis-ci.org), which presently loads a small suite of programs, most notably [Ubuntu `v. 16.04.6`](https://ubuntu.com/), [GNU `bash` `v. 4.3.48(1)-release`](https://git.savannah.gnu.org/cgit/bash.git) , [`git` `v. 2.21.0`](https://git-scm.com/), and [`Docker` `v. 18.06.0-ce`](https://www.docker.com).

Within our [Travis CI job](https://docs.travis-ci.com/user/job-lifecycle/), we use the [`bash` language](https://git.savannah.gnu.org/cgit/bash.git) and set the user with `sudo` privileges.


### Docker

To use a container approach, we need to have `Docker` installed first. 

Because the standard [Travis CI](https://travis-ci.org) `bash` runtime environment comes pre-loaded with `Docker` (`v. 18.06.0-ce`), we do not need to install it during our continuous integration workflow in order to use containers.

However, this may not to be the case for users establishing local versions of the pipeline.
If needed, then, [install `Docker`](https://docs.docker.com/get-docker/).
The specific instructions vary depending on your operating system, so pay special attention to that.


### Collecting Software Images

Following [best practices for Docker containers](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/), we have decoupled our overall workflow into two major components, each of which has its own image:
1. Data retrieval via the [`accessor` image](https://hub.docker.com/r/dapperstats/accessor)
2. Data summary/analysis/presentation via the [`salvage` image](https://hub.docker.com/r/dapperstats/salvage)

It is likely that in the future the second stage will be further decoupled into separate image (*e.g.*, "summary and analysis" and "presentation"), but that is not yet enacted.


We then pull the remote images of the Docker containers from [Docker Hub](https://hub.docker.com/) to the Travis server:

```{bash, eval = FALSE}
docker pull dapperstats/accessor
docker pull dapperstats/salvage
```


### Instantiating Containers

At this point we can now `docker run` the images to produce containers in our runtime:

```{bash, eval = FALSE}
docker run --name acc --restart=always -it dapperstats/accessor
docker run --name salv --restart=always -itd dapperstats/salvage
```

We name the containers `acc` and `salv` for `accessor` and `salvage`, respectively, and keep them restarted so that their content is more quickly accessible.
The containers are ephemeral in that they will be destroyed at the end of the workflow; no services will need them, so they will not be left on and running.
The additional flags used are
 - `-d` runs the container in the background (needed because there is no command line within `salvage`)
 - `-i` keeps the container's `stdin` open
 - `-t` allocates a pseudo-TTY to the `stdin`



## Populating Files


### Data Access


#### Retrieve the Salvage Database

The [`accessor` image](https://hub.docker.com/r/dapperstats/accessor) is defined with the software necessary to retrieve a remote Access<sup>&reg;</sup> database (`.accdb` or `.mdb`), convert it to a set of `.csv` files named by the tables in the database, and read the `.csv` files into [`R`](https://www.r-project.org/). 

The `accessor` image also contains `bash` scripts to perform the retrieval and conversion, which are executed at the creation of a container from the `accessor` image.

The default settings for the image are configured for the "current" (1993 - Present) salvage database, so the `acc` container will include the most up-to-date version of the salvage data, collected within the `data` folder. 
Code for the construction of the `accessor` image and details of its scripts are available in its [repository](https://www.github.com/dapperstats/accessor).


#### Share the Data 

The data that the `acc` container creates are located within its read-write layer and need to be shared to the build folder for archiving as well as to the `salv` container for analysis and presentation.

The main `Docker` command for moving files around is `cp`.
At the present, however, there is no capacity in `Docker` to copy between containers.
Rather, we copy the `data` folder out from `acc` to the local folder and then copy from the local folder into `salv`:

```{bash, eval = FALSE}
docker cp acc:/data .
docker cp data salv:/
```

**N.B.**: any existing files within the local `data` folder will be overwritten with the up-to-date versions.


### Script Access


#### Share the Scripts 

Whereas the `acc` container got us an accessible version of the data, the `salv` container is where we are going to summarize, analyze, and present the data; all of which is facilitated by pre-written scripts and functions.

The scripts within the `acc` container include some functions, especially for reading the `.csv` files into `R`, that we would like to have within the `salv` container, so we follow the method used above for the data for copying scripts:

```{bash, eval = FALSE}
docker cp acc:/scripts .
docker cp scripts salv:/
```

**N.B.**: the files in the local `scripts` folder will be overwritten by the `acc` container's versions and then any scripts in the local folder will overwrite any already-existing files in the `salv` container.

As long as this is managed appropriately, the copying of scripts allows the user to add more scripts of their choosing into the container.
This is done by simply adding them in the local `scripts` folder prior to running the above line (`docker cp scripts salv:/`).


### Site Access


#### Bring the Site into `salv`

The website is comprised of a suite a folders and files that are contained within a folder named `site`.

The `accessor` image has nothing to do with the site whatsoever, so we do not need to copy anything regarding the site from the container.

We do, however, have a local instance of the `site` folder, which we need to copy into `salv`:


```{bash, eval = FALSE}
docker cp site salv:/
```

At this point, the `salv` container is loaded with the software, scripts, data, and website content necessary to summarize, analyze, and present the salvage data.

## Salvage Analyses & Presentation

Having created a runtime environment within the `salv` container that includes the necessary programs, data, and scripts to analyze and present the salvage data, we can use the `docker exec` to execute a command within the container.

Of specific note, the `salv` container is built on the [`rocker/r-rmd` image](https://hub.docker.com/r/rocker/r-rmd), which contains the latest (at the time of building the image) release of base [`R` (presently `v. 3.6.2`)](https://www.r-project.org/) and the necessary libraries to construct and render `Rmarkdown`-flavored documents (*e.g.*, the website). 

The container also includes up-to-date (at the time of image creation) versions of the `R` [`blogdown` package (`v. 0.17`)](https://github.com/rstudio/blogdown) and [`Hugo` (`v. 0.63.2`)](https://github.com/gohugoio/hugo) for additional website-rendering capability.

To keep the overall code tidy at the `travis.yml` level, we package all of the necessary R code for analyses and presentation, including website rendering, within a single script (`salvage_script.R`), 
which we execute within `salv`:

```{bash, eval = FALSE}
docker exec -i salv R -e "source('scripts/salvage_script.R')"
```

The `-i` flag keeps the container's `stdin` open.

The `-e` flag allows the input for the `R` command to be an expression. 


### `R` Salvage Script

The `salvage_script.R` file consists of a few component blocks of code that leverage functions in the scripts to orchestrate the analysis and presentation.

Presently, these include

1. Source the `acc` and `salv` functions
```{R, eval = FALSE}
source("scripts/r_functions.R")
source("scripts/salvage_functions.R")
```
2. Read the Database into `R`
```{R, eval = FALSE}
salvage <- read_database()
``` 
  - `salvage` is a `list` of `data.frames` that is directly analagous to the `.accdb` database of tables and the folder of `.csv` files
  - `read_database` has arguments to allow direction to alternative file locations but default settings are for this pipeline
3. Calculate all daily volumes and counts for Chinook, Steelhead, Striped Bass, and Delta Smelt at both facilities:
```{R, eval = FALSE}
species <- c(1:3, 26)
daily_salvage_tab <- daily_salvage(salvage, "1993-01-01", Sys.Date(), species)
```
4. Calculate and plot the daily exported volumes from both facilities
```{R, eval = FALSE}
dates <- seq.Date(as.Date("2020-01-01"), Sys.Date(), 1)
exported_volumes <- daily_exported_volume(salvage, dates)
exported_volumes_fig(exported_volumes)
```
5. Render the website
```{R, eval = FALSE}
rmarkdown::render_site("site")
```
6. Notify
```{R, eval = FALSE}
message("completed")
```


### Adding to the `R` execution

It is possible to add to the executed `R` code in one of two ways: 
1. Add to the `salvage_script.R` file
2. Add to the `docker exec` command

For [1], add code directly to your local `scripts/salvage_script.R`, save the file, and re-run
```{bash, eval = FALSE}
docker cp scripts salv:/
``` 
to copy the file into the container.

For [2], if you are adding a brief bit of `R` code, you can simply expand the `R -e` character input
```{bash, eval = FALSE}
sudo docker exec -i salvage R -e "source('scripts/salvage_script.R'); <additional_R_code>"
```
(replacing <additional_R_code> with the actual code). 

Alternatively, if your code is complex enough to warrant its own script, save it to a file `scripts/<your_scripts_name>.R` (replacing <your_scripts_name> with the actual file name), copy the file into the container
```{bash, eval = FALSE}
docker cp scripts salv:/
``` 
and then expand the `R -e` character input
```{bash, eval = FALSE}
docker exec -i salv R -e "source('scripts/salvage_script.R'); source('scripts/<your_scripts_name>.R')"
```
Note that we are still running the main `salvage_script.R` first here, which sources the function, loads the data, and puts the daily salvage table and current year's daily exported volumes into the working environment (as `daily_salvage_tab` and `exported_volumes`, respsectively).


## Retrieving the Results

We use the `cp` command again to move the resulting data (summary files are saved in `data/summaries`) and site files from the `salv` container out to the local space
```{bash, eval = FALSE}
docker cp salv:/data .
docker cp salv:/site .
```


# Data Preparation

We now detail the data-focused procedures enclosed within the `salvage_script.R`.

These routines are used to prepare, analyze, and present the data once they are loaded into `R` and can be used with other versions of the database loaded similarly into `R`, but perhaps in a non-containerized setting.

We use the functions included in the [`salvage_functions.R` R script](https://github.com/dapperstats/salvage/blob/master/scripts/salvage_functions.R), which is included within the [`salvage` docker image](https://hub.docker.com/r/dapperstats/salvage) and in the `scripts` folder of the repository.


## Daily Summaries

The data in the Sample table are at the highest frequency (sample level, generally every 2-hr).
For the present work we summarize the volumes and counts at the daily level within each of two buildings (CVP, SWP).

For a given sample, the amount of time (minutes) the facility was pumping, the amount of time (minutes) of the pumping that was sampled, and the primary flow (cubic feet per second) are recorded.

We convert the flow to cubic meters per minute and assume an average primary flow over the sample times to estimate sample-specific pumping and sampling volumes, which we then sum within days to produce daily totals in 1000 m<sup>3</sup>. For comparison, we also include the total daily exported volume reported in the Sample table, converted to 1000 m<sup>3</sup>. This value should be similar to the calculated daily totals, and indeed the values are very strongly aligned (correlation coefficient of 0.952 for CVP and 0.996 for SWP for 9,893 daily values from 1993-01-01 to 2020-02-01).

As an additional sample size metric, we also include the total number of included entries (samples) within each day for each building (general target being 12). 


To determine the total daily counts for each organism of interest, we gather the entries in the Catch table that are aligned with all samples for that day in that building and sum across their counts. 

These counts are the number of times a fish of that species was found in the processed sample volume, which is a fraction of the total volume sampled.

For a quick and simple expansion to a full-volume estimate (*e.g.*, for plotting) we divide the count by the sample volume and multiply by the pumped volume (as calculated).

We note, however, that this expansion is not fully appropriate at the boundary when no fish are caught within the sample, but fish are present in the exported water.



# References 

White, E. P., G. M. Yenni, S. Taylor, E. Christensen, E. Bledsoe, J. L. Simonis, and S. K. M. Ernest. 2019. Developing an automated iterative near-term forecasting system for an ecological study. Methods in Ecology and Evolution 10:332-344. DOI: [10.1111/2041-210X.13104](https://doi.org/10.1111/2041-210x.13104).
