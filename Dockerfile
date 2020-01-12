# Base image is r-base
FROM r-base

# Add libraries
RUN apt-get update \
    && apt-get install -y \
       curl \
       mdbtools \
       unixodbc-dev

# Move the container initialization instructions file into the image
COPY scripts/container_start.bash scripts/container_start.bash

# When the container is created, run the initialization instructions file
# Default setting is to use R with the salvage ftp
ARG LANG=R
ARG DBFILE="ftp://ftp.wildlife.ca.gov/salvage/Salvage_data_FTP.accdb"
ENV CONTAINER_LANG=LANG
ENV CONTAINER_DBFILE=DBFILE

CMD ["bash", "scripts/container_start.bash"]#, "$CONTAINER_LANG", "$CONTAINER_DBFILE"]