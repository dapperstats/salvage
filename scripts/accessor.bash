#!/bin/bash
# requirements: curl, mdbtools, unixodbc-dev

# Pull values from options and fill if needed
while getopts ":r:l:t:d:x:" option
  do
    case "${option}" 
      in
        r ) REMOTE_DB_FILE=$OPTARG;;
        l ) LOCAL_DB_FILE=$OPTARG;;
        t ) TEMP_DB_FILE=$OPTARG;;
        d ) DATA_DIR=$OPTARG;;
        x ) REMOVE_TEMP_DB_FILE=$OPTARG;;
        \? ) echo "Invalid option: $OPTARG" 1>&2;;
        : ) echo "Invalid option: $OPTARG requires an argument" 1>&2;;
    esac
done
if [ ! "$REMOTE_DB_FILE" ] && [ ! "$LOCAL_DB_FILE" ] 
  then
    echo "error: must supply -r (remote db file address) or -l (local db file address)"
    exit 1
fi

if [ "$REMOTE_DB_FILE" ]
  then
echo $REMOTE_DB_FILE
    bash scripts/retrieve_remote_db.bash  -r $REMOTE_DB_FILE #-t $TEMP_DB_FILE -d $DATA_DIR
fi