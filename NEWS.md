# Salvage Tools

Version numbers follow [Semantic Versioning](https://semver.org/).

# [v0.9.0](https://github.com/dapperstats/salvage/releases/tag/v0.9.0)
*2022-12-02*

## Shifting build workflow from travis to Github Actions
* cron workflow implementing the image-based pipeline
* tag workflow building and publishing image updates
* both workflows proceed but do not finish on PRs

## Move dockerfile into a folder
* Create a docker folder for holding dockerfile and readme

# [v0.8.0](https://github.com/dapperstats/salvage/releases/tag/v0.8.0) 
*2020-01-29*

## Fixing a hiccup with the `salvage_script`
* I had forgotten to remove a placeholder that was keeping the last date to use fixed
* Removed now, image updated

# [v0.7.0](https://github.com/dapperstats/salvage/releases/tag/v0.7.0) 
*2020-01-28*

## Actual CI web interaction
* I think?
* I hope!

## Stripped down web design
* Just uses the basic `rmarkdown::render_site`

# [v0.6.0](https://github.com/dapperstats/salvage/releases/tag/v0.6.0) 
*2020-01-26*

## Website meets CI output
* Minimal, but successful integration of output from the docker image into the website.
* Now just given as the date of the last sample on the FTP.

## Hookup with Zenodo
* Addresses [https://github.com/dapperstats/salvage/issues/17]

# [v0.5.0](https://github.com/dapperstats/salvage/releases/tag/v0.5.0) 
*2020-01-25*

## Website

* Integration with [salvage.fish](https://salvage.fish)
* Starting point, set up with netlify
* Not yet populated with the data summary

## Ongoing work on the R script to make the data summary

* Some basic functions are set up and running
* Travis runs the script in the container that reads in and uses the db
* Produce proper tables for output
* They do pass through CI

# [v0.4.0](https://github.com/dapperstats/salvage/releases/tag/v0.4.0) 
*2020-01-17*

## Moving docker image building code to accessor repo

## Shifting over to use of accessor here

# [v0.3.0](https://github.com/dapperstats/salvage/releases/tag/v0.3.0) 
*2020-01-13*

## Updated `Dockerfile`
* Now allows for `--build-arg` options for all of the environment variables used in the `bash` scripts.
  * Most notable is `i` which allows for the toggling on or off of the interactive `R` session

## Updated `Docker` images
* Standard existing image is now generalized: [dapperstats/salvage:v0.3.0](https://hub.docker.com/layers/dapperstats/salvage/0.3.0/images/sha256-3d68b02010770ebb5414851fffcd913b26a38c7c72a26217a8d491560e63a86b)
* New standard image for non-interactive session is created: [dapperstats/salvage_nonint:v0.3.0](https://hub.docker.com/layers/dapperstats/salvage_nonint/0.3.0/images/sha256-b4825ef5fd47e3e4e391e66050786b65ba18c8c4a8328acbf90464c809968698) 
  * This is a new [image repository on dockerhub](https://hub.docker.com/repository/docker/dapperstats/salvage_nonint)

## Integration with [Travis-CI](https://travis-ci.org/dapperstats/salvage)
* Daily `cron` job retrieves, converts, uploads, and tags the data
  * `.travis.yml` leverages the non-interactive image to build only the `.csv` files (no `R` session is started)
  * `update_github_data.bash` is what's run `after_success` for `cron` jobs only
    * Uses @dapperdeploy as the user bpt
    * Updates the main branch with the `.csv`s and `.txt` date log
    * Creates a tag based on the date, and deploys the tag as a release


# [v0.2.0](https://github.com/dapperstats/salvage/releases/tag/v0.2.0) 
*2020-01-12*

## Bug fixing of `R` functionality
* Now fully integrated into `Dockerfile` such that created containers now have a `list` of `data.frame`s

## Isolation of mdb functionality from `container_start.bash`
* Database procurement and unpackaging now occurs via a generalized script `remote_mdb_to_local_csv.bash`, which has core functionality that can be used in other situations.
* `container_start.bash` runs `remote_mdb_to_local_csv.bash` and `r_script.R`, which sources the `R` functions and loads the database as a `list`.

## Updated `Docker` image
* [v0.2.0](https://hub.docker.com/layers/dapperstats/salvage/0.2.0/images/sha256-224f226aa90eb94a6730c7e95f5f8013bc2c150258d090c0df6e97769a3ef044)

## Inclusion of this here [`NEWS`](https://github.com/dapperstats/salvage/blob/main/NEWS.md)

# [v0.1.0](https://github.com/dapperstats/salvage/releases/tag/v0.1.0) 
*2020-01-12*

## Initial Creation of salvage codebase
* `Dockerfile` that creates `salvage:0.1.0`  image
* Focal `bash` script (`container_start.bash`) creates the local  `.csv`s from remote `.accdb`
* Rough (not fully functional, not yet included) `R` functions for turning the `.csv`s into a `list` of `data.frame`s
