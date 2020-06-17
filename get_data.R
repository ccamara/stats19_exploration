source("init.R")


# Data download -----------------------------------------------------------

years <- c(2009:2018)

for (i in years) {
  df <- get_stats19(year = i, type = "accident", ask = FALSE)
  
  write.csv(df, file = paste0("data/raw/", "accident", i, ".csv"))
}


# Calculate number of accidents per year and type. ------------------------

datalist = list()

for (i in years ) {

  tmp_summary_accidents <- get_stats19(year = i, type = "accident", ask = FALSE) %>% 
    group_by(accident_severity) %>% 
    tally() %>% 
    mutate(year = as.character(i))
  
  # summary_accidents <- data.frame(accident_severity = character(), n = numeric(), year = character())
  # 
  # summary_accidents <- union(summary_accidents, tmp_summary_accidents)
  # 
  # remove(tmp_summary_accidents)
  datalist[[i]] <- tmp_summary_accidents # add it to your list
}

summary_accidents2 <- dplyr::bind_rows(datalist)

write.csv(summary_accidents, file = "data/interim/summary_accidents.csv")


# Calculate number of casualities per year --------------------------------

# Create an empty dataframe.
summary_casualties = data.frame(
  n = as.numeric(),
  year = as.character()
)

for (i in years ) {
  
  tmp_summary_casualties <- get_stats19(year = i, type = "accident", ask = FALSE) %>% 
    select(number_of_casualties) %>% 
    tally() %>% 
    mutate(year = as.character(i))

  summary_casualties <- union(summary_casualties, tmp_summary_casualties) # add it to your list
}

write.csv(summary_casualties, file = "data/interim/summary_casualties.csv")


# Download casualties -----------------------------------------------------

casualties2018 <- get_stats19(year = 2018, type = "casualties", ask = FALSE) 

write.csv(casualties2018, file = "data/raw/casualties2018.csv")
