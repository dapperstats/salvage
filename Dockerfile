# the rocker rmarkdown image is the base
FROM rocker/r-rmd

# the R package blogdown is required to render sites in rmarkdown
RUN R -e "install.packages('blogdown')" 

# Hugo is required to run blogdown
RUN R -e "blogdown::install_hugo()" 

# Copy in the scripts directory
COPY scripts scripts