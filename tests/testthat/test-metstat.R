test_that("search_metstat constructs correct query string", {
  client <- mw_rest_client()

  mock_request <- function(client, endpoint, format = NULL) {
    list(endpoint = endpoint)
  }

  mock_response_to_df <- function(x) x

  with_mocked_bindings(
    mw_request = mock_request,
    response_to_df = mock_response_to_df,
    {
      # Test with all empty parameters
      result <- search_metstat(client)
      expect_match(result$endpoint, "metstat/;;;;;;;")

      result <- search_metstat(client,
        analysis_type = "LCMS",
        species = "Human",
        sample_source = "Blood"
      )
      expect_match(result$endpoint, "metstat/LCMS;;;Human;Blood;;;")

      # Test with all parameters
      result <- search_metstat(client,
        analysis_type = "LCMS",
        polarity = "POSITIVE",
        chromatography = "RP",
        species = "Human",
        sample_source = "Blood",
        disease = "Diabetes",
        kegg_id = "C00002",
        refmet_name = "Glucose"
      )
      expect_match(result$endpoint, "metstat/LCMS;POSITIVE;RP;Human;Blood;Diabetes;C00002;Glucose")
    }
  )
})

test_that("search_metstat handles URL encoding", {
  client <- mw_rest_client()

  mock_request <- function(client, endpoint, format = NULL) {
    list(endpoint = endpoint)
  }

  mock_response_to_df <- function(x) x

  with_mocked_bindings(
    mw_request = mock_request,
    response_to_df = mock_response_to_df,
    {
      # Test with special characters
      result <- search_metstat(client, refmet_name = "D-Glucose 6-phosphate")
      expect_match(result$endpoint, "D-Glucose%206-phosphate")
    }
  )
})
