context("test-team11")

# - Function specifications:
#   - name: `team11`
# - Parameters file and tolerance, first is a string and second is numeric
# - Function should error if `file` is not string or `tolerance` is not numeric
# - Function should return a dataframe

test_that("team11 works as expected", {
  expect_error(team_11(./data/gadm36_AUS_shp/gadm36_AUS_1.shp, 0.1))
  expect_error(team_11("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", IA))
})
