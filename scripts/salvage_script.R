source("scripts/r_functions.R")
source("scripts/salvage_functions.R")
salvage <- read_database()

most_recent_samples(salvage)
dates <- seq.Date(as.Date("2020-01-01"), as.Date("2020-01-22"), 1)
daily_volume(salvage, dates)
x <- daily_values(salvage, dates, organism = 21)
plot(as.Date(x$Date), x$Sample_Volume/x$Pumping_Volume)

hist(x$Exported_Volume * x$Sample_Volume/x$Pumping_Volume)
message("completed")