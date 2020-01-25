salvage <- read_database()

most_recent_samples(database)
dates <- seq.Date(as.Date("2020-01-01"), as.Date("2020-01-22"), 1)
daily_volume(database, dates)
daily_counts(database, dates)
