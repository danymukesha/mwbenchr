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

test_that("print method works for mw_rest_client with cache", {
    client <- mw_rest_client(cache = TRUE)
    expect_true(client$cache)
})

test_that("print method works for mw_request", {
    client <- mw_rest_client()
    study_id <- "ST000001"
    endpoint <- paste0("study/study_id/", study_id, "/summary")
    expect_no_error(mw_request(client, endpoint,
        parse = FALSE,
        c(cache = TRUE, content_type = "application/json")
    ))

    expect_error(mw_request(client, endpoint, wrong = "wrong"))
})


test_that("print method works for mw_request with cache", {
    client <- mw_rest_client(cache = TRUE)
    study_id <- "ST000001"
    endpoint <- paste0("study/study_id/", study_id, "/summary")
    expect_no_error(mw_request(client, endpoint,
        parse = FALSE
    ))

    expect_error(mw_request(client, endpoint, wrong = "wrong"))
})


test_that("print.mw_rest_client prints correctly", {
    client <- list(
        base_url = "https://example.com/api",
        cache = TRUE,
        timeout = 30,
        cache_dir = "/path/to/cache"
    )
    class(client) <- "mw_rest_client"

    captured_output <- capture.output(print(client))

    expect_true(grepl("Metabolomics Workbench REST Client", captured_output[1]))
    expect_true(grepl("  Base URL: https://example.com/api", captured_output[2]))
    expect_true(grepl("  Caching: Enabled", captured_output[3]))
    expect_true(grepl("  Timeout: 30 seconds", captured_output[4]))
    expect_true(grepl("  Cache directory: /path/to/cache", captured_output[5]))
})
