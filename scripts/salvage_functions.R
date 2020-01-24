
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



daily_counts <- function(salvage, dates = NULL, organism = 26, 
                         facility = c("SWP", "CVP"), study = 0){
  sample_method <- as.numeric(factor(facility, levels = c("SWP", "CVP")))
  sample_method <- 1:2
  if(is.null(dates)){
    dates <- max(salvage$Sample$SampleDate, na.rm = TRUE)
  }
  dates <- as.character(dates)
  tab <- expand.grid(SampleMethod = sample_method, SampleDate = dates, 
                     Organism = organism, 
                     stringsAsFactors = FALSE)
  nrows <- NROW(tab)
  catch <- rep(NA, nrows)
  pumping_time <- rep(NA, nrows)
  sample_time <- rep(NA, nrows)
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

    sample_ids <- salvage$Sample$SampleRowID[all_in]
    sample_in <- salvage$Building$SampleRowID %in% sample_ids

    building_ids <- salvage$Building$BuildingRowID[sample_in]
    catch_in <- salvage$Catch$BuildingRowID %in% building_ids
    species_in <- salvage$Catch$Organism == tab$Organism[i]
    all_in <- catch_in & species_in
    catches <- salvage$Catch$Count[all_in]
    catch[i] <- sum(catches, na.rm = TRUE)

  }
  out <- data.frame(tab, catch, nsamples, pumping_time, sample_time) 
  out$SampleMethod[out$SampleMethod == 1] <- "SWP"
  out$SampleMethod[out$SampleMethod == 2] <- "CVP"
  colnames(out) <- c("Building", "Date", "Species", "Count", "Samples",
                     "Pumping_Time", "Sample_Time")
  out
}



 # note: the database has the AcreFeet being the TOTAL DAILY acre feet 
  # of water exported for that day, so we use the mean with na.rm = TRUE
  # simply to reduce the data stream and in case there's accidentally more
  # than one unique value (there should be only one)

daily_volume <- function(salvage, dates = NULL, units = "thousand_m3",
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