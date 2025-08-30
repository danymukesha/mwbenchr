test_that("compound functions construct correct endpoints", {
  client <- mw_rest_client()

  mock_request <- function(client, endpoint, format = NULL, parse = TRUE) {
    list(endpoint = endpoint, format = format, parse = parse)
  }

  mock_response_to_df <- function(x) x

  with_mocked_bindings(
    mw_request = mock_request,
    response_to_df = mock_response_to_df,
    resp_body_string = function(x) "mock_structure",
    {
      result <- get_compound_by_regno(client, "1")
      expect_match(result$endpoint, "compound/regno/1/all")

      result <- get_compound_by_regno(client, "1", fields = "name")
      expect_match(result$endpoint, "compound/regno/1/name")

      result <- get_compound_by_pubchem_cid(client, "5793")
      expect_match(result$endpoint, "compound/pubchem_cid/5793/all")

      result <- get_compound_classification(client, "regno", "1")
      expect_match(result$endpoint, "compound/regno/1/classification")

      result <- download_compound_structure(
        client, "regno", "1",
        "molfile",
      )
      expect_no_error(result)
    }
  )
})

test_that("download_compound_structure validates format", {
  client <- mw_rest_client()

  expect_error(
    download_compound_structure(client, "regno", "1", "invalid"),
    "format must be one of: molfile, sdf"
  )
})
