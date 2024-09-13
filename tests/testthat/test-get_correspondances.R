test_that("get_correspondances() returns a none-empty data.frame of 12 columns", {
  if (!curl::has_internet()) {
    skip("No internet connection")
  }
  correspondance <- swissMunicipalities::get_correspondances(start_period = "2024-01-01", end_period = "2024-08-01")
  expect_s3_class(correspondance, "data.frame")
  expect_true(nrow(correspondance) > 1)
  expect_true(ncol(correspondance) == 12)
  correspondance_csv <- readr::read_csv("https://sms.bfs.admin.ch/WcfBFSSpecificService.svc/AnonymousRest/communes/correspondances?startPeriod=01-01-2024&endPeriod=01-08-2024", show_col_types = FALSE)
  expect_identical(correspondance, correspondance_csv)
})
