#!/bin/bash
# requirements: curl, mdbtools, unixodbc-dev

# Default values
REMOTE_DB_FILE=ftp://ftp.wildlife.ca.gov/salvage/Salvage_data_FTP.accdb 
LOCAL_DB_FILE=local.accdb
DATA_DIR=data

# Pull values from options
while getopts ":r:l:d:" option
  do
    case "${option}" 
      in
        r ) REMOTE_DB_FILE=$OPTARG;;
        l ) LOCAL_DB_FILE=$OPTARG;;
        d ) DATA_DIR=$OPTARG;;
        \? ) echo "Invalid option: $OPTARG" 1>&2;;
        : ) echo "Invalid option: $OPTARG requires an argument" 1>&2;;
    esac
done

# Create the data subdirectory
mkdir $DATA_DIR -p

# Download the database
curl $REMOTE_DB_FILE --output $DATA_DIR/$LOCAL_DB_FILE

# Convert the database tables to csv files
mdb-tables -1 $DATA_DIR/$LOCAL_DB_FILE | xargs -L1 -d '\n' -I{} bash -c 'mdb-export "$1" "$2" > "$3"' -- $DATA_DIR/$LOCAL_DB_FILE {} $DATA_DIR/{}.csv