#' This function extracts a data from a shapefile with 2 levels in spf$geometry.
#'
#' @param file Path to your shapefile.
#' @param tolerance The tolerance value in the metric of the input object, default is 0.1.
#' @export
#' @return A dataframe extracted from a shapefile with group, longitude, latitude and order.
#' @examples
#' team_11("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", 0.1)

team_11 <- function(file, tolerance = 0.1) {
  library(tidyverse)
  library(sf)
  ozbig <- read_sf(file)
  oz_st <- maptools::thinnedSpatialPoly(as(ozbig, "Spatial"), tolerance, minarea = 0.001, topologyPreserve = TRUE)
  oz <- st_as_sf(oz_st)
  extract_data_L2 <- function(spf) {
  # Reads in the shapefile and extracts data from nested lists, finally
  # recording them into one data frame with columns: long, lat, group and
  # order.
    map_depth(.x = spf$geometry, 2, .f = c(1)) %>% flatten %>%
    map_dfr(data.frame, .id = "group") -> df
  # rename columns
    colnames(df) <- c("group", "long", "lat")
  # add new variable = "order"
    df$order <- seq(from = 1, to = nrow(df), by = 1)
    return(df)
  }
  ozplus <- extract_data_L2(oz)
  return(ozplus)
}
