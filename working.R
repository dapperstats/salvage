source("scripts/salvage_functions.R")
source("../../accessor/scripts/r_functions.R")

salvage <- read_database()

most_recent_samples(salvage)
dates <- seq.Date(as.Date("2020-01-01"), as.Date("2020-01-22"), 1)
daily_volume(salvage, dates)


site_dir <- "site"
dir.create(site_dir, showWarnings = FALSE)
blogdown::new_site(dir = site_dir, theme = "thomasheller/crab")
