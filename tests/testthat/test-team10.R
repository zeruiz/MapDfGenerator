context("test-team10")
# - Function specification:
# - name: 'team10'
# - parameter tolerance should be numeric
# - function should error if tolerance is not numeric
# - parameter path is string
# - function should return a dataframe
test_that("team10 work as expected", {
  expect_error(team10(tolerance, 2))
  expect_error(team10(path, I))
  #expect_s3_class(shpSmall, "data.frame")
})
