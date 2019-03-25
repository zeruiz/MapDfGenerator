#' This function extracts a data from a shapefile with 2 levels in spf$geometry, and include the other information.
#'
#' @param file Path to your shapefile.
#' @param tolerance The tolerance value in the metric of the input object, default is 0.1.
#' @import tidyverse
#' @import sf
#' @export
#' @return A dataframe extracted from a shapefile with group, longitude, latitude and order and additional information.
#' @examples
#' file <- system.file("gadm36_AUS_shp", "gadm36_AUS_1.shp", package = "MapDfGenerator")
#' team_11(file, 0.1)

team_11 <- function(file, tolerance = 0.1) {

  #Check the input type
  checkmate::assertCharacter(file)
  checkmate::assertNumber(tolerance)

  #Get data
  ozbig <- read_sf(file)
  AbsPath <- file.path(getwd(), file)
  assertthat::assert_that(file.exists(AbsPath), msg = "File does not exist!")
  oz_st <- maptools::thinnedSpatialPoly(as(ozbig, "Spatial"), tolerance, minarea = 0.001, topologyPreserve = TRUE)
  oz <- st_as_sf(oz_st)

  #Extract location info
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

  #Add additional info
  length <- map_depth(.x = oz$geometry, 2, .f = c(1)) %>%
    map(function(x) map(.x = x, .f = length)) %>%
    map(unlist) %>%
    map(sum) %>%
    unlist
  dat <- cbind(data.frame(oz$GID_0, oz$NAME_0, oz$GID_1, oz$NAME_1, oz$TYPE_1, oz$ENGTYPE_1, oz$CC_1, oz$HASC_1) %>%
    slice(rep(1:n(), length/2)), ozplus)
  return(dat)
  # check the output is a dataframe
  checkmate::checkDataFrame(dat)
}
