source("scripts/salvage_functions.R")
source("../../accessor/scripts/r_functions.R")

salvage <- read_database()


most_recent <- most_recent_samples(salvage)
daily_salvage_table <- daily_salvage(salvage, "1993-01-01", Sys.Date(), 1:2)
write.csv(daily_salvage_table, "../daily_salvage_table.csv", row.names = FALSE)


par(mfrow = c(2,1), mar = c(3, 4, 1, 1), bty = "L")
org_dens <- daily_salvage_table$organism_1 / daily_salvage_table$Sample_Volume
org_counts <- org_dens * daily_salvage_table$Pumping_Volume

plot(as.Date(daily_salvage_table$Date), org_counts)


org_dens <- daily_salvage_table$organism_2 / daily_salvage_table$Sample_Volume
org_counts <- org_dens * daily_salvage_table$Pumping_Volume

plot(as.Date(daily_salvage_table$Date), org_counts)

