test_that("bfs_muni_mutations() returns a none-empty data.frame of 14 columns", {
  if (!curl::has_internet()) {
    skip("No internet connection")
  }
  mutation <- BFS.muni::bfs_muni_mutations(start_period = "2024-01-01", end_period = "2024-08-01")
  expect_s3_class(mutation, "data.frame")
  expect_true(nrow(mutation) > 1)
  expect_true(ncol(mutation) == 14)
  mutation_csv <- readr::read_csv("https://sms.bfs.admin.ch/WcfBFSSpecificService.svc/AnonymousRest/communes/mutations?startPeriod=01-01-2024&endPeriod=01-08-2024", show_col_types = FALSE)
  expect_identical(mutation, mutation_csv)
})
