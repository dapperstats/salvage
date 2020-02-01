daily_salvage <- function(salvage, date_from = "2019-01-01", 
                          date_to = Sys.Date(), organism = 1, 
                          facility = c("SWP", "CVP"), study = 0){

  date_from <- as.Date(date_from)
  date_to <- as.Date(date_to)
  dates <- seq.Date(date_from, date_to, 1)

  vols <- daily_volumes(salvage = salvage, dates = dates, 
                        facility = facility, study = study)
  counts <- daily_counts(salvage = salvage, dates = dates, 
                         organism = organism, facility = facility, 
                         study = study)
  counts_sample_match <- match(paste0(counts$Building, "_", counts$Date),
                               paste0(vols$Building, "_", vols$Date)) 
  counts_cols_out <- c("Building", "Date")
  counts_cols <- !(colnames(counts) %in% counts_cols_out)
  counts1 <- data.frame(counts[counts_sample_match, counts_cols])
  colnames(counts1) <- colnames(counts)[counts_cols]
  data.frame(vols, counts1)
}



exported_volumes_fig <- function(vals){

  on.exit(dev.off())
  fname <- "site/files/exported_volumes.png"
  png(fname, width = 6, height = 5, units = "in", res = 200)
  par(bty = "U", mar = c(3, 5, 1, 5))

  rows_in <- vals$Building == "SWP"
  x <- as.Date(vals$Date[rows_in])
  y <- vals$Exported_Volume[rows_in]
  x <- x[!(is.na(y))]
  y <- y[!(is.na(y))]
  xlim <- range(x)
  ylim <- c(0, max(y))
  plot(1, 1, type = "n", xaxt = "n", yaxt = "n", xlab = "", ylab = "",
       xlim = xlim, ylim = ylim)
  points(x, y, type = "o", lwd = 3, pch = 16)
  axis(2, las = 1)
  txt <- expression(paste("State Water Project Daily Export (1000 m"^"3",")"))
  mtext(side = 2, txt, line = 3.5)

  par(new = TRUE)
  rows_in <- vals$Building == "CVP"
  x <- as.Date(vals$Date[rows_in])
  y <- vals$Exported_Volume[rows_in]
  x <- x[!(is.na(y))]
  y <- y[!(is.na(y))]
  xlim <- range(x)
  ylim <- c(0, max(y))
  plot(1, 1, type = "n", xaxt = "n", yaxt = "n", xlab = "", ylab = "",
       xlim = xlim, ylim = ylim)
  points(x, y, type = "o", lwd = 3, pch = 16, col = grey(0.6))
  axis(4, las = 1)
  txt <- expression(paste("Central Valley Project Daily Export (1000 m"^"3",
                          ")"))
  mtext(side = 4, txt, line = 3.5)

  mtext(side = 3, "SWP", col = 1, at = min(x), font = 2)
  mtext(side = 3, "CVP", col = grey(0.6), at = max(x), font = 2)

  allx <- seq.Date(min(x), max(x), by = 1)
  axis(1, at = allx, labels = F, tck = -0.005)
  monthx <- seq.Date(min(x), max(x), by = "month")
  month_lab <- as.character(monthx)
  axis(1, at = monthx, labels = month_lab)
  if(length(monthx) == 1){
    weekx <- seq.Date(min(x), max(x), by = "week")
    week_lab <- as.character(weekx)
    axis(1, at = weekx, labels = week_lab)
  }

}

most_recent_samples <- function(salvage){
  out <- rep(NA, 2)
  for(i in 1:2){
    rows_in <- salvage$Sample$SampleMethod == i
    sample_dates <- salvage$Sample$SampleDate[rows_in]
    out[i] <- max(sample_dates, na.rm = TRUE)
  }  
  names(out) <- c("SWP", "CVP")
  out
}


daily_counts <- function(salvage, dates = NULL, organism = 1, 
                              facility = c("SWP", "CVP"), study = 0){

  sample_method <- as.numeric(factor(facility, levels = c("SWP", "CVP")))
  sample_method <- 1:2
  if(is.null(dates)){
    dates <- max(salvage$Sample$SampleDate, na.rm = TRUE)
  }
  dates <- as.character(dates)
  tab <- expand.grid(SampleMethod = sample_method, SampleDate = dates, 
                     stringsAsFactors = FALSE)
  nrows <- NROW(tab)
  ncols <- length(organism)
  samples_counts <- matrix(NA, nrow = nrows, ncol = ncols)

  for(i in 1:nrows){
    sample_method_in <- salvage$Sample$SampleMethod == tab$SampleMethod[i]
    sample_date_in <- salvage$Sample$SampleDate == tab$SampleDate[i]
    study_row_id_in <- salvage$Sample$StudyRowID %in% study 
    all_in <- sample_method_in & sample_date_in & study_row_id_in
    sample_row_id <- salvage$Sample$SampleRowID[all_in]
    sample_row_id_in <- salvage$Building$SampleRowID %in% sample_row_id

    building_row_id <- salvage$Building$BuildingRowID[sample_row_id_in]
    building_row_id_in <- salvage$Catch$BuildingRowID %in% building_row_id
    for(j in 1:ncols){
      organism_in <- salvage$Catch$Organism == organism[j]
      all_in <- building_row_id_in & organism_in
      sample_counts <- salvage$Catch$Count[all_in]
      samples_counts[i, j] <- sum(sample_counts, na.rm = TRUE)
    }
  }
  out <- data.frame(tab, samples_counts) 
  out$SampleMethod[out$SampleMethod == 1] <- "SWP"
  out$SampleMethod[out$SampleMethod == 2] <- "CVP"
  organism_col_names <- paste0("organism_", organism)
  colnames(out) <- c("Building", "Date", organism_col_names)
  out
}

daily_volumes <- function(salvage, dates = NULL, 
                          facility = c("SWP", "CVP"), study = 0){

  pumping_times <- salvage$Sample$MinutesPumping
  sample_times <- salvage$Sample$SampleTimeLength
  flows <- salvage$Sample$PrimaryFlow # cubic feet per second
  flows <- flows * 60 # cubic feet per minute
  flows <- flows * 0.0283168 # cubic meters per minute
  flows <- flows * 1/1000 # 1000 cubic meters per minute

  pumping_vols <- pumping_times * flows
  sample_vols <- sample_times * flows

  salvage$Sample$PumpingVol <- pumping_vols
  salvage$Sample$SampleVol <- sample_vols

  sample_method <- as.numeric(factor(facility, levels = c("SWP", "CVP")))
  sample_method <- 1:2
  if(is.null(dates)){
    dates <- max(salvage$Sample$SampleDate, na.rm = TRUE)
  }
  dates <- as.character(dates)
  tab <- expand.grid(SampleMethod = sample_method, SampleDate = dates, 
                     stringsAsFactors = FALSE)
  nrows <- NROW(tab)
  pumping_time <- rep(NA, nrows)
  sample_time <- rep(NA, nrows)
  pumping_vol <- rep(NA, nrows)
  sample_vol <- rep(NA, nrows)
  vol <- rep(NA, nrows)
  nsamples <- rep(NA, nrows)

  for(i in 1:nrows){
    building_in <- salvage$Sample$SampleMethod == tab$SampleMethod[i]
    date_in <- salvage$Sample$SampleDate == tab$SampleDate[i]
    study_in <- salvage$Sample$StudyRowID %in% study 
    all_in <- building_in & date_in & study_in

    nsamples[i] <- sum(all_in)

    pumping_times <- salvage$Sample$MinutesPumping[all_in]
    sample_times <- salvage$Sample$SampleTimeLength[all_in]
    pumping_time[i] <- sum(pumping_times, na.rm = TRUE)
    sample_time[i] <- sum(sample_times, na.rm = TRUE)

    pumping_vols <- salvage$Sample$PumpingVol[all_in]
    sample_vols <- salvage$Sample$SampleVol[all_in]
    pumping_vol[i] <- sum(pumping_vols, na.rm = TRUE)
    sample_vol[i] <- sum(sample_vols, na.rm = TRUE)

    vols <- salvage$Sample$AcreFeet[all_in]
    vol[i] <- mean(vols, na.rm = TRUE)


  }
  vol <- convert_volume_units(vol, "AF", "thousand_m3")

  out <- data.frame(tab, nsamples, pumping_time, sample_time,
                    pumping_vol, sample_vol, vol) 
  out$SampleMethod[out$SampleMethod == 1] <- "SWP"
  out$SampleMethod[out$SampleMethod == 2] <- "CVP"
  colnames(out) <- c("Building", "Date", "Samples",
                     "Pumping_Time", "Sample_Time",
                     "Pumping_Volume", "Sample_Volume", "Exported_Volume")
  out
}



 # note: the database has the AcreFeet being the TOTAL DAILY acre feet 
  # of water exported for that day, so we use the mean with na.rm = TRUE
  # simply to reduce the data stream and in case there's accidentally more
  # than one unique value (there should be only one)

daily_exported_volume <- function(salvage, dates = NULL, 
                                  units = "thousand_m3",
                                  facility = c("SWP", "CVP")){
  sample_method <- as.numeric(factor(facility, levels = c("SWP", "CVP")))
  if(is.null(dates)){
    dates <- max(salvage$Sample$SampleDate, na.rm = TRUE)
  }
  dates <- as.character(dates)
  tab <- expand.grid(SampleMethod = sample_method, SampleDate = dates, 
                     stringsAsFactors = FALSE)
  nrows <- NROW(tab)
  val <- rep(NA, nrows)
  for(i in 1:nrows){
    building_in <- salvage$Sample$SampleMethod == tab$SampleMethod[i]
    date_in <- salvage$Sample$SampleDate == tab$SampleDate[i]
    all_in <- building_in & date_in
    vals <- salvage$Sample$AcreFeet[all_in]
    val[i] <- mean(vals, na.rm = TRUE)
  }
  val <- convert_volume_units(val, "AF", units)
  out <- data.frame(tab, val) 
  out$SampleMethod[out$SampleMethod == 1] <- "SWP"
  out$SampleMethod[out$SampleMethod == 2] <- "CVP"
  colnames(out) <- c("Building", "Date", "Volume_Exported")
  out
}


convert_volume_units <- function(val, units_from, units_to){
  if(units_from == units_to){
    return(vals)
  }
  units_tab <- data.frame(from = "AF", 
                          to = "thousand_m3", 
                          mult = 1233.48/1000)

  units_from_in <- units_tab$from == units_from
  units_to_in <- units_tab$to == units_to
  units_in <- units_from_in & units_to_in
  val * units_tab[units_in, "mult"]
}