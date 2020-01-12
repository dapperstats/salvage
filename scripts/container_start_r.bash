#!/bin/bash
CONTAINER_DBFILE=ftp://ftp.wildlife.ca.gov/salvage/Salvage_data_FTP.accdb 
DATA_DIR=data

# Create the data subdirectory
mkdir DATA_DIR

# Download the database
curl CONTAINER_DBFILE --output DATA_DIR/Salvage_data_FTP.accdb

# Convert the access database to csv files
mdb-tables -1 DATA_DIR/Salvage_data_FTP.accdb | xargs -L1 -d '\n' -I{} bash -c 'mdb-export $DATA_DIR/Salvage_data_FTP.accdb "$1" >$DATA_DIR/"$1".csv' -- {}

# Open an instance of R
R 