
#' Create a heatmap.
#' @description Creates a heatmap map with all locations.
#' @param spdf Spatial Dataframe
#' @param schools CSV file with geocoded schools.
rsd_oc_heatmap <- function(spdf, location = NULL) {
  # References:
  # https://rpubs.com/bhaskarvk/leaflet-heat
  
  spdf <- spdf %>% 
    filter(!is.na(latitude))
  
  if (!is.null(location)) {
    spdf <- filter(spdf, school == location)
  }


  leaflet(spdf, options = leafletOptions(minZoom = 0, maxZoom = 14)) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addHeatmap(lng = ~longitude, lat = ~latitude,
               blur = 20, max = 0.05, radius = 15 ) %>%
    addMiniMap(tiles = providers$CartoDB.Positron)
}

#' Create a dots map with categories.
#' @description Creates a map with all locations, categorized according to a
#'   category, adds a legend and school's position.
#' @param df Regular Dataframe
#' @param my_category Category that will be used for classification. Can be a
#'   vector.
#' @param my_title String that will be used for legend's title.
#' @param schools CSV file with geocoded schools.
bbk_map_category <- function(df, my_category, my_title = NULL, schools = NULL) {
  df <- df %>%
    filter(is.na(msg)) %>%
    mutate(lon = as.numeric(lon)) %>%
    mutate(lat = as.numeric(lat))
  # Convert dataframe into spatial feature.
  df.sf <- st_as_sf(x = df, coords = c("lon", "lat"),
                    crs = "+proj=longlat +datum=WGS84")
  if (is.null(schools)) {
    map <- tm_shape(df.sf) +
      tm_basemap("CartoDB.Positron") +
      tm_dots(size = .1, popup.vars = "respondent_name", id = "respondent_name",
              title = my_title, palette =  "RdYlBu",
              col = my_category)
    # tm_markers()

  } else {
    school_icon <- tmap_icons(here('icons', 'school-solid.png'))

    schools.df <- read.csv(here("data/raw/", schools))

    schools.df.sf <- st_as_sf(x = schools.df, coords = c("lon", "lat"),
                              crs = "+proj=longlat +datum=WGS84")

    map <- tm_shape(df.sf) +
      tm_basemap("CartoDB.Positron") +
      tm_dots(size = .1, popup.vars = "respondent_name", id = "respondent_name",
              title = my_title, palette =  "RdYlBu",
              col = my_category) +
      tm_shape(schools.df.sf) +
      tm_symbols(shape = school_icon, size = 0.1)
  }
  tmap_leaflet(map)
}

#' Create horizontal barplots.
#' @description Creates a horizontal barplot using ggplot.
#' @param df Regular Dataframe
#' @param my_category Category that will be used for classification. Can be a
#'   vector.
#' @param my_title String that will be used for Plot's title.
barplot_horizontal <- function(df, my_category, my_title) {

  my_category <- enquo(my_category)

  df <- df %>%
    select(!! my_category) %>%
    filter(!! my_category != "") %>%
    group_by(!! my_category) %>%
    summarise(total = n()) %>%
    arrange(desc(total)) %>%
    mutate(order = "1")
  # %>%
  #   mutate(!! my_category = str_wrap(!! my_category, width = 20))

  # View(df)


  p <- ggplot(df, aes_q(x = quote(order), y = quote(total), fill = my_category)) +
    geom_bar(stat = "identity", position = "fill") +
    geom_text(aes(label = total),
              colour = "white",
              position = position_fill(vjust = 0.5)) +
    scale_y_continuous(labels = percent(c(0, 0.25, 0.5, 0.75, 1))) +
    ggtitle(my_title) +
    labs(x = "", y = "% de respuestas", fill = "") +
    scale_fill_brewer(palette = "Pastel1", direction = -1) +
    theme_minimal() +
    theme(axis.text.y = element_blank()) +
    theme(legend.position = "bottom") +
    guides(fill=guide_legend(ncol=2)) +
    coord_flip()

  print(p)

}


#' Create horizontal histogram.
#' @description Creates a horizontal histogram using ggplot.
#' @param df Regular Dataframe
#' @param my_category Category that will be used for classification. Can be a
#'   vector.
#' @param my_title String that will be used for Plot's title.
histogram_horizontal <- function(df, my_category, my_title) {

  my_category <- enquo(my_category)

  df <- df %>%
    select(!! my_category) %>%
    filter(!! my_category != "")

  total_answers <- nrow(df)

  df <- df %>%
    group_by(!! my_category) %>%
    summarise(total = n()) %>%
    arrange(desc(total)) %>%
    mutate(!! my_category := fct_reorder(!! my_category, total))

  p <- ggplot(df, aes_q(x = my_category, y = quote(total))) +
    geom_bar(stat = "identity", fill = "#3C8DBC") +
    geom_text(aes(label = total),
              colour = "white",
              position = position_stack(vjust = 0.5)) +
    scale_x_discrete(labels = function(x) str_wrap(x, width = 20)) +
    # scale_y_continuous(labels = percent(c(0, 0.25, 0.5, 0.75, 1))) +
    ggtitle(my_title) +
    labs(x = "", y = paste(total_answers, "erantzun", sep = " "), fill = "") +
    scale_fill_brewer(palette = "Pastel1", direction = -1) +
    theme_minimal() +
    guides(fill = guide_legend(ncol = 2)) +
    coord_flip()

  p

}