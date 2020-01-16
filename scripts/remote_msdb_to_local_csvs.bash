#!/bin/bash
# requirements: curl, mdbtools, unixodbc-dev

# Pull values from options and fill if needed
while getopts ":r:l:d:x:" option
  do
    case "${option}" 
      in
        r ) REMOTE_DB_FILE=$OPTARG;;
        l ) LOCAL_DB_FILE=$OPTARG;;
        d ) DATA_DIR=$OPTARG;;
        x ) REMOVE_LOCAL_DB_FILE=$OPTARG;;
        \? ) echo "Invalid option: $OPTARG" 1>&2;;
        : ) echo "Invalid option: $OPTARG requires an argument" 1>&2;;
    esac
done
if [ ! "$REMOTE_DB_FILE" ] && [ ! "$LOCAL_DB_FILE" ] 
  then
    echo "error: must supply -r (remote db file address) or -l (local db file address)"
    exit 1
fi


if [ ! "$LOCAL_DB_FILE" ] 
  then
    LOCAL_DB_FILE="${REMOTE_DB_FILE##*/}"
    if [ ! "$REMOVE_LOCAL_DB_FILE" ]
    then
      REMOVE_LOCAL_DB_FILE=y
    fi
  else
    echo "pooooooo"
    if [ ! "$REMOVE_LOCAL_DB_FILE" ]
      then
        REMOVE_LOCAL_DB_FILE=n
    fi
fi
if [ ! "$DATA_DIR"] 
then
  DATA_DIR=data
fi
DB_DIR=$DATA_DIR/"${LOCAL_DB_FILE%%.*}"

# Create the data directory with a database subdirectory
mkdir $DB_DIR -p

# Download the database (if needed)
if [ "$REMOTE_DB_FILE" ]
then
  curl $REMOTE_DB_FILE --output $DATA_DIR/$LOCAL_DB_FILE
fi

# Convert the database tables to csv files
mdb-tables -1 $DATA_DIR/$LOCAL_DB_FILE | xargs -L1 -d '\n' -I{} bash -c 'mdb-export "$1" "$2" > "$3"' -- $DATA_DIR/$LOCAL_DB_FILE {} $DB_DIR/{}.csv

# Remove database file (if request)
if [ "$REMOVE_LOCAL_DB_FILE" == y ]
  then
    sudo rm -rf $DATA_DIR/$LOCAL_DB_FILE
fi 