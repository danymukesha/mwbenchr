test_that("get_study_summary constructs correct endpoint", {
  client <- mw_rest_client()

  mock_request <- function(client, endpoint, format = NULL) {
    list(endpoint = endpoint, format = format)
  }

  mock_response_to_df <- function(x) x

  with_mocked_bindings(
    mw_request = mock_request,
    response_to_df = mock_response_to_df,
    {
      result <- get_study_summary(client)
      expect_match(result$endpoint, "study/study_id/ST/summary")

      result <- get_study_summary(client, "ST000001")
      expect_match(result$endpoint, "study/study_id/ST000001/summary")

      result <- get_study_summary(client, "ST000001", "txt")
      expect_match(result$endpoint, "study/study_id/ST000001/summary/txt")
    }
  )
})

test_that("study functions construct correct endpoints", {
  client <- mw_rest_client()
  study_id <- "ST000001"

  mock_request <- function(client, endpoint, format = NULL) {
    list(endpoint = endpoint)
  }

  mock_response_to_df <- function(x) x

  with_mocked_bindings(
    mw_request = mock_request,
    response_to_df = mock_response_to_df,
    {
      result <- get_study_factors(client, study_id)
      expect_match(result$endpoint, "study/study_id/ST000001/factors")

      result <- get_study_metabolites(client, study_id)
      expect_match(result$endpoint, "study/study_id/ST000001/metabolites")

      result <- get_study_data(client, study_id)
      expect_match(result$endpoint, "study/study_id/ST000001/data")
    }
  )
})
