# Functions for loading the salvage database from .csv files into R objects.
#
# TL;DR:
# - read_database() brings the salvage .csvs into R as a list of data.frames
#
# Details:
# - The database is a list and the tables are data.frame objects
# - The code is broken out to be interchangable
# - Each table has its own read_<table_name> function, which just calls a 
#   read_csv function that provides the standard processing around reading csv
#   (in particular verifying that the file exists and returning gracefully
#    but with a message if the file doesn't).
# - files into R and generating a data.frame
# - The names of the tables to load by default is generated using the 
#   db_table_names, which at its default NULL, returns all of the tables.
# - Specific subsets of the data can easily be coded into read_database 
#   via the table_names argument
# - The code can be pointed at any folder location the user has access to 
#   that includes the database .csv files, due to the data_dir argument,
#   which points to the directory where the data are. By default it is set
#   to "./data", but it can be pointed elsewhere if needed.

message("loading functions for database access")

db_table_names <- function(tables_in = NULL){
  if(is.null(tables_in)){
    out <- c("building", "catch", "dna_cwt", "larval_length", "length", 
             "organisms", "sample", "stations", "studies", "units", 
             "variables", "variable_codes")
  } else if(is.na(tables_in)){
    out <- NA
  } else{
    out <- tables_in
  }
  out
}

read_database <- function(table_names = db_table_names(), 
                          data_dir = "./data", quiet = FALSE){
  if(!quiet){
    message("reading in database .csv files")
  }
  out <- lapply(table_names, read_table, data_dir = data_dir)
  names(out) <- table_names
  out
} 

read_table <- function(table_name = "building", data_dir = "./data"){
  function_name <- paste0("read_", table_name)
  do.call(function_name, args = list(data_dir = data_dir))
}

read_building <- function(data_dir = "./data"){
  read_csv("Building", data_dir = data_dir)
}

read_catch <- function(data_dir = "./data"){
  read_csv("Catch", data_dir = data_dir)
}

read_dna_cwt <- function(data_dir = "./data"){
  read_csv("DNAandCWTRace", data_dir = data_dir)
}

read_larval_length <- function(data_dir = "./data"){
  read_csv("LarvalFishLength", data_dir = data_dir)
}

read_length <- function(data_dir = "./data"){
  read_csv("Length", data_dir = data_dir)
}

read_organisms <- function(data_dir = "./data"){
  read_csv("OrganismsLookUp", data_dir = data_dir)
}

read_sample <- function(data_dir = "./data"){
  read_csv("Sample", data_dir = data_dir)
}

read_stations <- function(data_dir = "./data"){
  read_csv("StationsLookUp", data_dir = data_dir)
}

read_studies <- function(data_dir = "./data"){
  read_csv("StudiesLookUp", data_dir = data_dir)
}

read_units <- function(data_dir = "./data"){
  read_csv("UnitsLookUp", data_dir = data_dir)
}

read_variables <- function(data_dir = "./data"){
  read_csv("VariablesLookUp", data_dir = data_dir)
}

read_variable_codes <- function(data_dir = "./data"){
  read_csv("VariableCodesLookUp", data_dir = data_dir)
}

read_csv <- function(file_name = "Sample", data_dir = "./data"){
  file_name <- paste0(file_name, ".csv")
  file_namel <- tolower(file_name)
  fopts <- list.files(data_dir)
  foptsl <- tolower(fopts)
  fopts_in <- which(foptsl %in% file_namel)
  nfopts_in <- length(fopts_in)
  if(nfopts_in == 0){
    return_msg <- paste0(file_name, " does not exist")
    message(return_msg)
    return(invisible(NULL))
  } else if(nfopts_in > 1){
    return_msg <- paste0("multiple matches for ", file_name)
    message(return_msg)
    return(invisible(NULL))
  }
  file_name <- fopts[fopts_in]
  fpath <- file.path(data_dir, file_name)
  read.csv(fpath, stringsAsFactors = FALSE)
}