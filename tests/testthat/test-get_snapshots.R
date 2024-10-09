test_that("bfs_muni_snapshots() returns a none-empty data.frame of 34 columns", {
  if (!curl::has_internet()) {
    skip("No internet connection")
  }
  snapshot <- BFS.muni::bfs_muni_snapshots(start_period = "2024-01-01", end_period = "2024-08-01")
  expect_s3_class(snapshot, "data.frame")
  expect_true(nrow(snapshot) > 1)
  expect_true(ncol(snapshot) == 34)
  snapshot_csv <- readr::read_csv("https://sms.bfs.admin.ch/WcfBFSSpecificService.svc/AnonymousRest/communes/snapshots?startPeriod=01-01-2024&endPeriod=01-08-2024", show_col_types = FALSE)
  expect_identical(snapshot, snapshot_csv)
})
