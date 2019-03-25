#' This function helps get the polygon and geographic information from a shapefile.
#'
#' @description Extract polygon and geographic information from a shapefile. The main function is built on that from team 12's work from Lab 2
#' @param file URL to local path to the shape data.
#' @param tolerance A number.
#' @import checkmate
#' @import tidyverse
#' @import dplyr
#' @export
#' @return A dataframe, containing polygon and geographic information like longitude, latitude, group and order.
#' @examples
#' file <- system.file("gadm36_AUS_shp", "gadm36_AUS_1.shp", package = "MapDfGenerator")
#' team_12(file, 0.1)


team_12 <- function(file, tolerance){
  add_order <- function(d){
    l <- nrow(d)
    return(cbind(d,seq(1,l,by=1)))
  }
  add_layer <- function(d){
    ll <- unlist(lapply(d,nrow))
    d <- do.call(rbind,d)
    d <- cbind(d,rep(c(1:length(ll)),time=ll))
    return(d)
  }
  helper <- function(d){
    d <- unlist(d,recursive = FALSE)
    d <- purrr::map(d,.f=add_order)
    d <- add_layer(d)
    return(d)
  }

  if(!is.numeric(tolerance)){
    warning('argument is not numeric or logical: returning NA')
    return(NA)
  }
  assertNumber(tolerance, lower = 0, upper = 1)
  assertCharacter(file)

  ozbig <- sf::read_sf(file)
  oz_st <- maptools::thinnedSpatialPoly(as(ozbig, "Spatial"), tolerance, minarea = 0.001, topologyPreserve = TRUE)
  oz <- sf::st_as_sf(oz_st)
  purrr::map(oz$geometry, .f=helper) -> res
  res <- add_layer(res)
  colnames(res) <- c('long','lat','order','group','geo')
  res <- as.data.frame(res)

  repnum <- table(res$geo)
  dat <- cbind(data.frame(oz$GID_0, oz$NAME_0, oz$GID_1, oz$NAME_1, oz$TYPE_1, oz$ENGTYPE_1, oz$CC_1, oz$HASC_1))
  dat %>% slice(rep(1:n(), times = repnum)) -> dat
  cbind(dat, res) -> dat
  return(dat)

  checkDataFrame(dat)
}
