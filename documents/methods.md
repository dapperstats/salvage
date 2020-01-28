# Methods

## Data Access


<br>

### Retrieve the Salvage Database

The bulk of the data access protocol involves converting the `.accdb` salvagae database file on the remote [ftp](ftp://ftp.dfg.ca.gov/salvage/) to a local set of `.csv` files named by the tables in the database. 
We accomplish this in two lines of code by pulling and then running a stable [`Docker`](https://www.docker.com) [software container](https://www.docker.com/resources/what-container) that contains a set of `bash` scripts designed specifically for this task.
The specific image used for data access is called [`accessor`](https://hub.docker.com/r/dapperstats/accessor), is freely available on [Docker Hub](https://hub.docker.com/), and has default setting configured for the salvage database.
Code for the construction of the `accessor` image is available in its [repository](https://www.github.com/dapperstats/accessor).

For accessability and reproducibility, we provide an [up-to-date version of the salvage data](https://github.com/dapperstats/salvage/blob/master/data) as `.csv`s from the "current" (1993 - Present) salvage database file (`Salvage_data_FTP.accdb`).
The data can be downloaded via various methods from the repository, including from the website.

Updates to the data are executed via [`cron` jobs](https://docs.travis-ci.com/user/cron-jobs/) on [`travis-ci`](https://travis-ci.org/dapperstats/salvage) and pushed to GitHub as [tagged Releases](https://github.com/dapperstats/salvage/releases).

<br> 

#### Build A Salvage Container

To use the current image to generate an up-to-date container with data for yourself

1. [Install Docker](https://docs.docker.com/get-docker/)
   * Specific instructions vary depending on OS
2. Open up a docker-ready terminal
3. Download the image
```{bash, eval = FALSE}
sudo docker pull dapperstats/salvage`
```
4. Build the container
```{bash, eval = FALSE}
sudo docker container run -ti --name salvage dapperstats/salvage`
```
5. Copy the data out from the container 
```{bash, eval = FALSE}
sudo docker cp salvage:/data .`
```

<br>

### Bring the Data into R 

An additional conversion makes the data available in [`R`](https://www.r-project.org/) as a `list` of `data.frames` that is directly analagous to the `.accdb` database of tables.

The reading into R is conducted via functions included in the `r_functions.R` script in the [`accessor` image](https://hub.docker.com/r/dapperstats/accessor) and available in the [public code repository](https://github.com/dapperstats/accessor/tree/master/scripts).

<br>

#### Within a Salvage Container

Building on the list above, you can leverage the `r_script.R` script included in the image, which sources the `r_functions.R` script and loads the database in as an `R` object named `database`. 
Docker provides ample access and avenues to run R within the container.
For example, the `docker exec` command opens a full API for running within the top (read/write) layer of the container, allowing an endless supply of R code to be included within a single character input:

6. Run a `bash` `R` script from the command line 
```{bash, eval = FALSE}
sudo docker exec -i salvage R -e "source('scripts/r_script.R'); <additional R code>"
```

You can copy your own scripts *into* the image and then run them from that environment:

7. Copying a script into the image
```{bash, eval = FALSE}
sudo docker cp path/to/my_r_script.R salvage:/scripts
```
8. Running the script in the image
```{bash, eval = FALSE}
sudo docker exec -i salvage R -e "source('scripts/r_script.R'); source('scripts/my_r_script.R')"
```

Note that we are running the main `r_script.R` first still here; that script does not save any files externally, so the R session in **6.** is gone when we run **8.**. 
For the sake of simplifying the command line call, it is therefore recommended that expanded uses follow **8.** and use `my_r_script.R` as a hub file that directs all of your specific functions, including files saved out from R.
For simplicity, saving out all files into a single folder, e.g. `output` allows a single docker command for retrieving the results from the top layer of the container:

9. Copy the output out from the container 
```{bash, eval = FALSE}
sudo docker cp salvage:/output .
```

<br>

#### Working in an Open R Session

Alternatively, the functions are written in only base R, so they **should** be reproducibly functional outside the image (in an open session).

Within an instance of `R`, navigate to where you have read the data out from the container into/where this code repository located and source `r_script.R`:

6. Load the functions and read in the data
```{R, eval = FALSE}
source("scripts/r_script.R")
```

The resulting `database` object is a named `list` of the database's tables, ready for analyses.

<br>

## Data Preparation

Data preparation code is *in development*!

Having brought the data into R as-is, we can now prepare them for summaries and analyses.
We use the functions included in the [`salvage_functions.R` R script](https://github.com/dapperstats/salvage/blob/master/scripts/salvage_functions.R), which is included within the and [`salvage` docker image](https://hub.docker.com/r/dapperstats/salvage), which provides a stable runtime environment for the analyses and output generation (including website rendering).

<br>

## Continuous Deployment

The data and output are updated daily via [`cron` jobs](https://docs.travis-ci.com/user/cron-jobs/) on [`travis-ci`](https://travis-ci.org/dapperstats/salvage) with a recipe (a.k.a. job lifecycle) described by the [`.travis.yml` file](https://github.com/dapperstats/salvage/blob/master/.travis.yml).

