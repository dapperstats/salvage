#!/bin/bash

# Create the data subdirectory
mkdir data

# Download the access database
curl ftp://ftp.wildlife.ca.gov/salvage/Salvage_data_FTP.accdb --output data/Salvage_data_FTP.accdb

# Convert the access database to csv files
mdb-tables -1 data/Salvage_data_FTP.accdb | xargs -L1 -d '\n' -I{} bash -c 'mdb-export data/Salvage_data_FTP.accdb "$1" >data/"$1".csv' -- {}

# Open an instance of R
R 