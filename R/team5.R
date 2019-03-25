




Mat2Df <- function(Mat){
  long <- Mat[,1]
  lat <- Mat[,2]
  order <- 1:nrow(Mat)
  group <- rep(stats::rnorm(1),nrow(Mat))
  df <- data.frame(long=long,lat=lat,group=group,order=order)
  df
}

#' The team_5 function utilize the map-dataframe-generator form team 5.
#'
#' @param file URL of local path to the shape data.
#' @param tolerance The tolerance value, default is 0.1.
#' @import methods
#' @import tidyverse
#' @import purrr
#' @import sf
#' @export
#' @return a dataframe of longitude, latitude, group, order and addtional information.
#' @examples
#' file <- system.file("gadm36_AUS_shp", "gadm36_AUS_1.shp", package = "MapDfGenerator")
#' team_5(file, 0.1)

team_5 <- function(file, tolerance){
  # input checking
  checkmate::assertCharacter(file)
  checkmate::assertNumber(tolerance)
  AbsPath <- file.path(getwd(), file)
  assertthat::assert_that(file.exists(AbsPath), msg = "File does not exist!")

  # data preparation
  ozbig <- read_sf(file)
  oz_st <- maptools::thinnedSpatialPoly(as(ozbig, "Spatial"), tolerance = tolerance, minarea = 0.001, topologyPreserve = TRUE)
  oz <- st_as_sf(oz_st)

  # Each element of the form oz$geometry[[i]][[j]] is a list with one element: a matrix with two columns
  # flatten the list to get an array of matrices
  oz_flatten <- flatten(flatten(oz$geometry))

  # foreach matrix, apply the Mat2Df function and combine the result to ozplus
  ozplus <- purrr::map_df(.x=oz_flatten,.f=Mat2Df)

  # ozplus %>% ggplot(aes(x = long, y = lat, group = group)) + geom_polygon()

  # add additiona information other than geometry info to ozplus.

  # for each field, caculate the number of  rows in ozplus that belongs to the field
  listlength <- function(ll){
    length(unlist(ll))/2
  }
  mylength <- purrr::map(.x = oz$geometry, .f = listlength ) %>% unlist

  # cannot use select() to select coluns from oz, use data.frame() instead
  add <- data.frame(oz$GID_0, oz$NAME_0, oz$GID_1, oz$NAME_1, oz$VARNAME_1, oz$NL_NAME_1, oz$TYPE_1, oz$ENGTYPE_1, oz$CC_1, oz$HASC_1)
  add <- add %>% slice(rep(1:n(), mylength))
  ozplusplus <- cbind(ozplus, add)

  # check the output is a dataframe
  checkmate::checkDataFrame(ozplusplus)

  return(ozplusplus)
}


#team_5("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", 0.1)  %>% ggplot(aes(x = long, y = lat, group = group)) + geom_polygon()
