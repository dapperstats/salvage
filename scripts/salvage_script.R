source("scripts/r_functions.R")
source("scripts/salvage_functions.R")
salvage <- read_database()

most_recent_samples(salvage)
dates <- seq.Date(as.Date("2020-01-01"), as.Date("2020-01-22"), 1)
daily_volume(salvage, dates)
x <- daily_sample_vols(salvage, dates)
plot(as.Date(x$Date), x$Sample_Volume/x$Pumping_Volume)

most_recent <- most_recent_samples(salvage)
most_recent <- data.frame(t(most_recent))
mr_file <- paste0("site/static/files/most_recent_samples.csv")
#write.csv(most_recent, file = mr_file, row.names = FALSE)
list.files()
message("completed")

