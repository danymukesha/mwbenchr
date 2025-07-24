test_that("Client initialization works", {
    client <- mw_rest_client()
    expect_s3_class(client, "mw_rest_client")
    expect_equal(client$base_url, "https://www.metabolomicsworkbench.org/rest")
})

test_that("Compound endpoint works", {
    client <- mw_rest_client()
    result <- get_compound_by_pubchem_cid(client, 5281365)
    expect_type(result, "list")
    expect_true("name" %in% names(result))
})
