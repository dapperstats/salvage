source("scripts/salvage_functions.R")
source("../../accessor/scripts/r_functions.R")

salvage <- read_database()

most_recent_samples(salvage)
dates <- seq.Date(as.Date("2020-01-01"), as.Date("2020-01-22"), 1)
daily_volume(salvage, dates)
vals <- daily_values(salvage, dates, organism = 21)

