context("test-team12")

# - Function specifications:
#   - name: `team12`
# - Parameters file and tolerance, first is a string and second is numeric
# - Function should error if `file` is not string or `tolerance` is not numeric
# - Function should return a dataframe

test_that("team12 works as expected", {
  filename <- system.file("extdata", "gadm36_AUS_1.shp", package = "MapDfGenerator")
  expect_error(team_12(filename, -0.5))
  expect_error(team_12(filename, 2))
  expect_error(team_12(filename, num))
  dat <- team_12(filename, 0.01)
  expect_s3_class(dat, "data.frame")
})
