context("getTSPInstanceOverview and filterTSPInstances")

test_that("getTSPInstanceOverview works well", {
  testdata = system.file("testdata", package = "salesperson")
  actual.files = list.files(testdata, pattern = ".tsp$")

  # without file path
  df = getTSPInstancesOverview(testdata)
  expect_is(df, "data.frame")
  expect_subset(c("dimension", "edge_weight_type"), choices = colnames(df))
  expect_true(all(dim(df) > 0))
  expect_equal(length(actual.files), nrow(df))

  # check with file path
  df = getTSPInstancesOverview(testdata, append.filename = TRUE)
  expect_is(df, "data.frame")
  expect_subset(c("dimension", "edge_weight_type", "file.path"), choices = colnames(df))
  expect_equal(length(actual.files), nrow(df))
})

test_that("filterTSPInstances works as a filter", {
  testdata = system.file("testdata", package = "salesperson")
  actual.files = list.files(testdata, pattern = ".tsp$")
  n = length(actual.files)

  # check for dimension
  df = filterTSPInstances(testdata, expr = quote(dimension > 100))
  expect_is(df, "data.frame")
  expect_true(nrow(df) < n)
  expect_true(all(df$dimension > 100))

  # check for more complicated subset
  df = filterTSPInstances(testdata,
    expr = quote(dimension >= 100 & dimension <= 1000 & edge_weight_type == "EUC_2D"))
  expect_is(df, "data.frame")
  expect_true(nrow(df) < n)
  expect_true(all(df$dimension >= 100 & df$dimension <= 1000))
  expect_true(all(df$edge_weight_type == "EUC_2D"))
  expect_true(all(is.logical(df$opt.tour.known)))
  expect_true(all(is.logical(df$opt.length.known)))

  # check if we get only tours with optimal values known (only a280.tsp in our testdata)
  df = filterTSPInstances(testdata, expr = TRUE, opt.known = TRUE)
  expect_is(df, "data.frame")
  expect_equal(nrow(df), 1L)

  # check for paths only
  df = filterTSPInstances(testdata,
    expr = quote(dimension > 100),
    paths.only = TRUE)
  expect_true(is.character(df))
  expect_true(length(df) > 0)
})
