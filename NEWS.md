# Salvage Tools

Version numbers follow [Semantic Versioning](https://semver.org/).

# [v0.2.0](https://github.com/dapperstats/salvage/releases/tag/v0.2.0) 
*2020-01-12*

## Bug fixing of `R` functionality
* Now fully integrated into `Dockerfile` such that created containers now have a `list` of `data.frame`s

## Isolation of mdb functionality from `container_start.bash`
* Database procurement and unpackaging now occurs via a generalized script `remote_mdb_to_local_csv.bash`, which has core functionality that can be used in other situations.
* `container_start.bash` runs `remote_mdb_to_local_csv.bash` and `r_script.R`, which sources the `R` functions and loads the database as a `list`.

## Updated `Docker` image
* [v0.2.0](https://hub.docker.com/layers/dapperstats/salvage/0.2.0/images/sha256-224f226aa90eb94a6730c7e95f5f8013bc2c150258d090c0df6e97769a3ef044)

## Inclusion of this here [`NEWS`](https://github.com/dapperstats/salvage/blob/master/NEWS.md)

# [v0.1.0](https://github.com/dapperstats/salvage/releases/tag/v0.1.0) 
*2020-01-12*

## Initial Creation of salvage codebase
* `Dockerfile` that creates `salvage:0.1.0`  image
* Focal `bash` script (`container_start.bash`) creates the local  `.csv`s from remote `.accdb`
* Rough (not fully functional, not yet included) `R` functions for turning the `.csv`s into a `list` of `data.frame`s
