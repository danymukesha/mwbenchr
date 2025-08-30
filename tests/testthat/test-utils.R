test_that("flatten_entry works with valid input", {
  entry <- list(
    study_id = "ST001",
    metabolite_name = "Glucose",
    metabolite_id = "MW001",
    DATA = data.frame(sample1 = 100, sample2 = 150)
  )

  result <- flatten_entry(entry)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 1)
  expect_true("study_id" %in% names(result))
  expect_true("sample1" %in% names(result))
  expect_equal(result$study_id, "ST001")
  expect_equal(result$sample1, 100)
})

test_that("flatten_entry handles missing metadata gracefully", {
  entry <- list(
    study_id = "ST001",
    DATA = data.frame(sample1 = 100)
  )

  result <- flatten_entry(entry)

  expect_true(is.na(result$metabolite_name))
  expect_equal(result$study_id, "ST001")
})

test_that("flatten_entry validates input", {
  expect_error(flatten_entry(list()), "Entry must be a list with a DATA element")
  expect_error(flatten_entry(list(name = "test")), "Entry must be a list with a DATA element")
  expect_error(flatten_entry("not_a_list"), "Entry must be a list with a DATA element")
})

test_that("response_to_df handles different response types", {
  # Empty response
  expect_equal(nrow(response_to_df(list())), 0)

  # Flat named list
  flat_response <- list(name = "Glucose", formula = "C6H12O6")
  result <- response_to_df(flat_response)
  expect_s3_class(result, "tbl_df")
  expect_equal(result$name, "Glucose")

  # Row-based response
  row_response <- list(
    Row1 = list(id = 1, name = "A"),
    Row2 = list(id = 2, name = "B")
  )
  result <- response_to_df(row_response)
  expect_equal(nrow(result), 2)
  expect_true("row_id" %in% names(result))
})

test_that("response_to_df validates input", {
  expect_error(response_to_df("not_a_list"), "Response must be a list")
  expect_error(response_to_df(123), "Response must be a list")
})

test_that("list_endpoints prints endpoint information", {
  client <- mw_rest_client()
  output <- capture_output(list_endpoints(client))

  expect_match(output, "Metabolomics Workbench REST API Endpoints")
  expect_match(output, "Compound Functions")
  expect_match(output, "Study Functions")
  expect_match(output, "get_compound_by_regno")
  expect_match(output, "get_study_summary")
})
