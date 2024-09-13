test_that("get_levels() returns a none-empty data.frame", {
  if (!curl::has_internet()) {
    skip("No internet connection")
  }
  level <- swissMunicipalities::get_levels(start_period = "2024-01-01", end_period = "2024-08-01")
  expect_s3_class(level, "data.frame")
  expect_true(nrow(level) > 1)
  level_csv <- readr::read_csv("https://sms.bfs.admin.ch/WcfBFSSpecificService.svc/AnonymousRest/communes/levels?startPeriod=01-01-2024&endPeriod=01-08-2024", show_col_types = FALSE)
  expect_identical(level, level_csv)
})
