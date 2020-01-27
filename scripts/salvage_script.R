source("scripts/r_functions.R")
source("scripts/salvage_functions.R")
salvage <- read_database()

most_recent_samples(salvage)
dates <- seq.Date(as.Date("2020-01-01"), as.Date("2020-01-22"), 1)
sample_vols <- daily_sample_vols(salvage, dates)
sv_table_file <- "files/sample_vols.csv"
write.csv(sample_vols, file = sv_table_file, row.names = FALSE)
sample_vol_fig(sample_vols)
message("hello")
most_recent <- most_recent_samples(salvage)
most_recent <- data.frame(t(most_recent))
mr_file <- "files/most_recent_samples.csv"
write.csv(most_recent, file = mr_file, row.names = FALSE)


message("completed")

