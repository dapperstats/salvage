source("scripts/salvage_functions.R")
source("../../accessor/scripts/r_functions.R")

salvage <- read_database()


most_recent <- most_recent_samples(salvage)

spp <- c(1:3, 26)
daily_salvage_tab <- daily_salvage(salvage, "1993-01-01", Sys.Date(), spp)
write.csv(daily_salvage_table, "../daily_salvage.csv", row.names = FALSE)




# split by facility 
# make prettier figures
# bibtex
# ABSTRACT
#
par(mfrow = c(4,1), mar = c(3, 4, 1, 1), bty = "L")
org_dens <- daily_salvage_tab$organism_1 / daily_salvage_tab$Sample_Volume
org_counts <- org_dens * daily_salvage_tab$Pumping_Volume

plot(as.Date(daily_salvage_table$Date), org_counts)


org_dens <- daily_salvage_tab$organism_2 / daily_salvage_tab$Sample_Volume
org_counts <- org_dens * daily_salvage_tab$Pumping_Volume

plot(as.Date(daily_salvage_tab$Date), org_counts)


org_dens <- daily_salvage_tab$organism_3 / daily_salvage_tab$Sample_Volume
org_counts <- org_dens * daily_salvage_tab$Pumping_Volume

plot(as.Date(daily_salvage_table$Date), org_counts)


org_dens <- daily_salvage_tab$organism_26 / daily_salvage_tab$Sample_Volume
org_counts <- org_dens * daily_salvage_tab$Pumping_Volume

plot(as.Date(daily_salvage_tab$Date), org_counts)