source("init.R")


# Data download -----------------------------------------------------------

# years <- c(1979:2019)
# 
# for (i in years) {
#   dl_stats19(year = i, data_dir = "data/raw/")
# }

dl_stats19(year = 2018, type = "Accidents", data_dir = "data/raw/", file_name = "2018_accidents.csv", silent = TRUE)
dl_stats19(year = 2018)

dl_stats19(year = 2018, type = "vehicles", data_dir = "data/raw/", file_name = "2018_vehicles.csv", silent = TRUE)

years <- c(2016:2018)

for (i in years) {
  df <- get_stats19(year = i, type = "accident", ask = FALSE)
  
  write.csv(df, file = paste0("data/raw/", "accident", i, ".csv"))
}


vehicles2018 <- get_stats19(year = 2018, type = "vehicles", ask = FALSE)
accidents2018 <- get_stats19(year = 2018, type = "accident", ask = FALSE)
accidents2017 <- get_stats19(year = 2017, type = "accident", ask = FALSE)
accidents2016 <- get_stats19(year = 2016, type = "accident", ask = FALSE)
accidents2015 <- get_stats19(year = 2015, type = "accident", ask = FALSE) %>% 
  group_by(accident_severity) %>% 
  tally() %>% 
  rename(total_accidents = n)

years <- c(2004:2018)


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

summary_accidents <- dplyr::bind_rows(datalist)

accidents %>% 
group_by(accident_severity) %>% 
  tally() 

accidents <- c(accidents2018, accidents2017, accidents2016, accidents2015)

for (i in accidents) {

  tmp_df <- as_tibble(i) %>% 
    select(accident_severity)
  # %>%
  #   rename(severity = accident_severity) %>% 
  #   group_by(severity) %>%
  #   summarise(Total = n()) %>%
  #   mutate(freq = Total/sum(Total)*100) %>%
  #   # arrange(desc(Total)) %>% 
  #   mutate(year = str_sub(deparse(substitute(i)), -4))
  # 
}

summary_severity_accidents2018 <- accidents2018 %>% 
  select(accident_severity) %>%
  group_by(accident_severity) %>%
  summarise(Total = n()) %>%
  mutate(freq = Total/sum(Total)*100) %>%
  # arrange(desc(Total)) %>% 
  mutate(year = 2018)

accidents2018 %>% 
  group_by(accident_severity) %>% 
  tally() 

accidents2018 %>% 
  count(accident_severity) 

tmp_df <- as.tibble(accidents2018) 


mtcars %>% count(cyl)
