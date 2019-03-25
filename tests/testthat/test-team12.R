context("test-team12")

# - Function specifications:
#   - name: `team12`
# - Parameters file and tolerance, first is a string and second is numeric
# - Function should error if `file` is not string or `tolerance` is not numeric
# - Function should return a dataframe

test_that("team12 works as expected", {
  expect_error(team_12(./data/gadm36_AUS_shp/gadm36_AUS_1.shp, 0.1))
  expect_error(team_12("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", -0.5))
  expect_error(team_12("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", 2))
  expect_error(team_12("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", num))
})
