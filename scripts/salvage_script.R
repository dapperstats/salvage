source("scripts/r_functions.R")
source("scripts/salvage_functions.R")

salvage <- read_database()
dir.create("site/files", showWarnings = FALSE)

# Most recent samples included
most_recent <- most_recent_samples(salvage)
max_date <- max(as.Date(most_recent))
most_recent <- data.frame(t(most_recent))
mr_file <- "site/files/most_recent_samples.csv"
write.csv(most_recent, file = mr_file, row.names = FALSE)

# Daily volumes and counts for Chinook, Steelhead, Striped Bass, Delta Smelt
species <- c(1:3, 26)
daily_salvage_tab <- daily_salvage(salvage, "1993-01-01", Sys.Date(), species)

# this year's samples



sv_table_file <- "site/files/sample_vols.csv"
write.csv(sample_vols, file = sv_table_file, row.names = FALSE)
exported_volumes_fig(sample_volumes)




rmarkdown::render_site("site")

message("completed")


