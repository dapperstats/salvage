#!/bin/bash

# Default values
REMOTE_DB_FILE=ftp://ftp.wildlife.ca.gov/salvage/Salvage_data_FTP.accdb 
LOCAL_DB_FILE=Salvage_data_FTP.accdb
DATA_DIR=data
INTERACTIVE=TRUE

# Pull values from options
while getopts ":r:l:d:i:" option
  do
    case "${option}" 
      in
        r ) REMOTE_DB_FILE=$OPTARG;;
        l ) LOCAL_DB_FILE=$OPTARG;;
        d ) DATA_DIR=$OPTARG;;
        i ) INTERACTIVE_R=$OPTARG;;
        \? ) echo "Invalid option: $OPTARG" 1>&2;;
        : ) echo "Invalid option: $OPTARG requires an argument" 1>&2;;
    esac
done

# Download and unpack the remote database into csv files
bash scripts/remote_mdb_to_local_csvs.bash -r $REMOTE_DB_FILE -l $LOCAL_DB_FILE -d $DATA_DIR

# For an interactive R session, run and save the r_script then open a session
if [ $INTERACTIVE_R == TRUE ]
  then 
    R < scripts/r_script.R --save
    R --silent
fi 