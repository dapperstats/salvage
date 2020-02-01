source("scripts/salvage_functions.R")
source("../../accessor/scripts/r_functions.R")

salvage <- read_database()

most_recent <- most_recent_samples(salvage)
daily_salvage_table <- daily_salvage(salvage)


org_dens <- daily_salvage_table$organism_1 / daily_salvage_table$Sample_Volume
org_counts <- org_dens * daily_salvage_table$Pumping_Volume

plot(as.Date(daily_salvage_table$Date), org_counts)

plot(daily_salvage_table$Pumping_Volume, daily_salvage_table$Exported_Volume)
abline(0,1)
