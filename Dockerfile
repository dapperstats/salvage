# Base image is rocker/verse
FROM rocker/tidyverse

# will add shiny server!
# RUN export ADD=shiny && bash /etc/cont-init.d/add