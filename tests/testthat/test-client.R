test_that("mw_rest_client creates valid client object", {
  client <- mw_rest_client()

  expect_s3_class(client, "mw_rest_client")
  expect_type(client, "list")
  expect_named(client, c("base_url", "cache", "cache_dir", "timeout"))
  expect_equal(client$base_url, "https://www.metabolomicsworkbench.org/rest")
  expect_false(client$cache)
  expect_equal(client$timeout, 30)
})

test_that("mw_rest_client validates parameters", {
  expect_error(mw_rest_client(base_url = 123), "base_url must be a character string")
  expect_error(mw_rest_client(cache = "yes"), "cache must be logical")
  expect_error(mw_rest_client(timeout = -1), "timeout must be a positive number")
  expect_error(mw_rest_client(timeout = c(1, 2)), "timeout must be a positive number")
})

test_that("mw_rest_client accepts custom parameters", {
  client <- mw_rest_client(
    base_url = "https://example.com/api",
    cache = TRUE,
    timeout = 60
  )

  expect_equal(client$base_url, "https://example.com/api")
  expect_true(client$cache)
  expect_equal(client$timeout, 60)
})

test_that("print method works for mw_rest_client", {
  client <- mw_rest_client()
  output <- capture_output(print(client))

  expect_match(output, "Metabolomics Workbench REST Client")
  expect_match(output, "Base URL.*https://www.metabolomicsworkbench.org/rest")
  expect_match(output, "Caching.*Disabled")
  expect_match(output, "Timeout.*30 seconds")
})
