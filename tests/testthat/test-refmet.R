test_that("refmet functions construct correct endpoints", {
  client <- mw_rest_client()

  mock_request <- function(client, endpoint, format = NULL) {
    list(endpoint = endpoint)
  }

  mock_response_to_df <- function(x) x

  with_mocked_bindings(
    mw_request = mock_request,
    response_to_df = mock_response_to_df,
    {
      result <- get_refmet_by_name(client, "Glucose")
      expect_match(result$endpoint, "refmet/name/Glucose/all")

      result <- get_refmet_by_name(client, "Glucose", "formula")
      expect_match(result$endpoint, "refmet/name/Glucose/formula")

      result <- standardize_to_refmet(client, "glucose")
      expect_match(result$endpoint, "refmet/match/glucose/name")

      result <- get_all_refmet_names(client)
      expect_match(result$endpoint, "refmet/name")
    }
  )
})

test_that("refmet functions handle URL encoding", {
  client <- mw_rest_client()

  mock_request <- function(client, endpoint, format = NULL) {
    list(endpoint = endpoint)
  }

  mock_response_to_df <- function(x) x

  with_mocked_bindings(
    mw_request = mock_request,
    response_to_df = mock_response_to_df,
    {
      result <- get_refmet_by_name(client, "D-Glucose 6-phosphate")
      expect_match(result$endpoint, "D-Glucose%206-phosphate")

      result <- standardize_to_refmet(client, "alpha-D-glucose")
      expect_match(result$endpoint, "alpha-D-glucose")
    }
  )
})
