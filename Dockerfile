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

# Set environmental variables to pass to container_start.bash
ENV REMOTE_DB_FILE="ftp://ftp.wildlife.ca.gov/salvage/Salvage_data_FTP.accdb" \
    LOCAL_DB_FILE=local.accdb \
    DATA_DIR=data

# When the container is built, execute container_start.bash
CMD bash scripts/container_start.bash -r $REMOTE_DB_FILE -l $LOCAL_DB_FILE -d $DATA_DIR
