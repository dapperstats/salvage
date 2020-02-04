# Source custom functions
source("scripts/r_functions.R")
source("scripts/salvage_functions.R")

# Read in the database
salvage <- read_database()

# All Daily volumes and counts [Chinook, Steelhead, Striped Bass, Delta Smelt]
species <- c(1:3, 26)
daily_salvage_tab <- daily_salvage(salvage, "1993-01-01", Sys.Date(), species)

# This year's daily exported volumes
dates <- seq.Date(as.Date("2020-01-01"), Sys.Date(), 1)
exported_volumes <- daily_exported_volume(salvage, dates)
exported_volumes_fig(exported_volumes)

# Render the website
rmarkdown::render_site("site")

message("completed")


