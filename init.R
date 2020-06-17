
# Load dependencies -------------------------------------------------------

library(DataExplorer)
library(DT)
library(flexdashboard)
library(formattable)
library(inspectdf)
library(mapillRy)
library(leaflet)
library(leaflet.extras)
library(lubridate)
library(plotly)
library(scales)
library(skimr)
library(stats19)
library(tidyverse)
library(ztable)

  files <- list.files(path = "R", pattern = "*.R", full.names = TRUE, recursive = FALSE)
for (i in files) {
  source(i)
}
