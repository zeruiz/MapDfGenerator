

#' geographic information
#'
#' @param path input file path usually as data/...
#' @param tolerance the amount of which data is getting small
#' @return a data frame consists of the geographic information of the polygons and the additional information (such as name of the country, name of the territory/state, ...)

#' @export
#' @examples
#' shpBigToSmall("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", 0.1)


#' @details
#' Three functions for geographic info
#' @references input data is available here ""
#' @keywords internal
"_PACKAGE"



shpBigToSmall <- function(path,tolerance) {
  shpbig <- read_sf(path)
  assert_that(has_extension("gadm36_AUS_1.shp", "shp"), #file path is correct
              is.numeric(tolerance)

              #,noNA(shpbig)
              )

  shp_st <- maptools::thinnedSpatialPoly(
    as(shpbig, "Spatial"), tolerance = tolerance,
    minarea = 0.001, topologyPreserve = TRUE)
  shp <- st_as_sf(shp_st)
  shpSmall <- shp %>% select(NAME_1, geometry) %>%
    group_by() %>%
    mutate(coord = geometry %>% map(.f = function(m) flatten(.x=m)),
           region = row_number()) %>%
    unnest
  st_geometry(shpSmall) <- NULL
  shpSmall <- shpSmall %>%
    mutate(coord = coord %>% map(.f = function(m) as_tibble(m)),
           group = row_number()) %>%
    unnest %>%
    setNames(c("name", "region","group", "long", "lat"))
  return(shpSmall)
  assert_that(
    is.data.frame(shpSmall),# output is data frame
    are_equal(ncol(shpSmall), 5) # correct # cols
    )

}
