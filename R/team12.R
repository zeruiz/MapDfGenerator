#' Map dataframe generator form Team 12.
#'
#' @param file URL to local path to the shape data.
#' @param tolerance A number.
#' @export
#' @return The dataframe of longitude, latitude, group and order.
#' @examples
#' team_12("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", 0.1)


team_12 <- function(file, tolerance){
  library(tidyverse)

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

  ozbig <- sf::read_sf(file)
  oz_st <- maptools::thinnedSpatialPoly(as(ozbig, "Spatial"), tolerance, minarea = 0.001, topologyPreserve = TRUE)
  oz <- sf::st_as_sf(oz_st)
  purrr::map(oz$geometry, .f=helper) -> res
  res <- add_layer(res)
  colnames(res) <- c('long','lat','order','group','geo')
  res <- as.data.frame(res)
  list(dataframe = res, name = oz$NAME_0[1])
}
