# Base image is r-base
FROM r-base

# Add libraries
RUN apt-get update \
    && apt-get install -y \
       curl \
       mdbtools \
       unixodbc-dev

# Move the scripts folder into the container
COPY scripts scripts

# Default values for arguments passed to environment variables
ARG r="ftp://ftp.wildlife.ca.gov/salvage/Salvage_data_FTP.accdb" 
ARG l=local.accdb 
ARG d=data 
ARG i=TRUE

# Set environment variables to pass to container_start.bash
ENV REMOTE_DB_FILE=$r \
    LOCAL_DB_FILE=$l \
    DATA_DIR=$d \
    INTERACTIVE_R=$i

# When the container is built, execute container_start.bash
CMD bash scripts/container_start.bash -r $REMOTE_DB_FILE -l $LOCAL_DB_FILE -d $DATA_DIR -i $INTERACTIVE_R
