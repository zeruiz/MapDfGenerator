context("test-team5")

#library(MapDfGenerator)

# - Check parameters, first should be a string and second should be numeric
# - Check if the path of file id correct
# - Check if the function returns a dataframe


test_that("team5 works as expected", {
  expect_error(team_5(./data/gadm36_AUS_shp/gadm36_AUS_1.shp, 0.1))
  expect_error(team_5("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", tolerance))
  expect_error(team_5("gadm36_AUS_1.shp", 0,1))
  #expect_true(is.data.frame(team_5("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", 0.1)))
})

