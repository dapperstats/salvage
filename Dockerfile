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
CMD ["bash", "scripts/container_start.bash"]