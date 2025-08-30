test_that("search_by_mass validates database parameter", {
  client <- mw_rest_client()

  expect_error(
    search_by_mass(client, "INVALID", 180, "M+H", 0.01),
    "db must be one of: MB, LIPIDS, REFMET"
  )
})

test_that("search_by_mass validates numeric parameters", {
  client <- mw_rest_client()

  expect_error(
    search_by_mass(client, "REFMET", "not_numeric", "M+H", 0.01),
    "mz must be numeric"
  )

  expect_error(
    search_by_mass(client, "REFMET", 180, "M+H", -0.01),
    "tolerance must be numeric and positive"
  )

  expect_error(
    search_by_mass(client, "REFMET", 180, "M+H", "not_numeric"),
    "tolerance must be numeric and positive"
  )
})
