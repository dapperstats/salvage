# Functions for loading a database from .csv files into an R list.
#
# TL;DR:
# - read_database() reads the .csvs in <data_dir>/<database>/ into R as a list 
#    of data.frames
#
# Details:
# - The database is a list and the tables are data.frame objects
# - Elements of the list are named as the .csv files, which are named as
#    as the tables in the database file
# - The code is generalized to work on any folder of csvs, regardless of the
#    number or names of files/tables
# - This code is intended to work on an accessor-generated database folder,
#    but will not be upset if other, non-.csv files are added to the database
#    folder.
# - Default behavior is to load all of the tables from .csvs into R, but
#    the tables loaded can be restricted through the tables argument.
# - The code can be pointed at any folder location the user has access to, it
#    does not need to be within the present working directory of the user 
#    thanks to the data_dir argument, which points to the directory
#    where the database folder lives.


read_database <- function(database = NULL, tables = NULL, 
                          data_dir = "data", quiet = FALSE){
  if(!quiet){
    message("reading in database .csv files")
  }
  data_dir_path <- file.path(data_dir)
  if(!file.exists(data_dir_path)){
    return_msg <- paste0(data_dir, " does not exist")
    stop(return_msg, call. = FALSE)
  }
  if(is.null(database)){
    database <- list.files(data_dir)[1]
  }
  db_path <- file.path(data_dir, database)
  if(!file.exists(db_path)){
    return_msg <- paste0(database, " does not exist")
    stop(return_msg, call. = FALSE)
  }
  if(is.null(tables)){
    tables <- csv_tables(database = database, data_dir = data_dir)
  }
  out <- lapply(tables, read_table, database = database, data_dir = data_dir)
  names(out) <- tables
  out
} 

csv_tables <- function(database = NULL, data_dir = "data"){
  data_dir_path <- file.path(data_dir)
  if(!file.exists(data_dir_path)){
    return_msg <- paste0(data_dir, " does not exist")
    stop(return_msg, call. = FALSE)
  }
  if(is.null(database)){
    database <- list.files(data_dir)[1]
  }
  db_path <- file.path(data_dir, database)
  if(!file.exists(db_path)){
    return_msg <- paste0(database, " does not exist")
    stop(return_msg, call. = FALSE)
  }
  file_names <- list.files(db_path)
  is_csv <- grepl(".csv", file_names)
  csv_names <- file_names[is_csv]
  gsub(".csv", "", csv_names)
}

read_table <- function(table = NULL, database = NULL, data_dir = "data"){
  data_dir_path <- file.path(data_dir)
  if(!file.exists(data_dir_path)){
    return_msg <- paste0(data_dir, " does not exist")
    stop(return_msg, call. = FALSE)
  }
  if(is.null(database)){
    database <- list.files(data_dir)[1]
  }
  db_path <- file.path(data_dir, database)
  if(!file.exists(db_path)){
    return_msg <- paste0(database, " does not exist")
    stop(return_msg, call. = FALSE)
  }

  file_name <- paste0(table, ".csv")
  if(is.null(table)){
    file_opts <- list.files(db_path)
    table_opts <- file_opts[grepl("\\.csv", file_opts)]
    file_name <- list.files(paste0(data_dir, "/", database))[1]
  }
  file_path <- file.path(data_dir, database, file_name)
  if(!file.exists(file_path)){
    return_msg <- paste0(table, " does not exist")
    message(return_msg)
    return(invisible(NULL))
  }
  read.csv(file_path, stringsAsFactors = FALSE)
}