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
    expect_equal(nrow(response_to_df(list())), 0)

    # Flat named list (single record)
    flat_response <- list(name = "Glucose", formula = "C6H12O6")
    result <- response_to_df(flat_response)
    expect_s3_class(result, "tbl_df")
    expect_equal(result$name, "Glucose")
    expect_equal(result$formula, "C6H12O6")

    # Row-based response (search results)
    row_response <- list(
        Row1 = list(id = 1, name = "A"),
        Row2 = list(id = 2, name = "B")
    )
    result <- response_to_df(row_response)
    expect_equal(nrow(result), 2)
    expect_true("row_id" %in% names(result))
    expect_equal(result$row_id, c("Row1", "Row2"))

    # Metabolite entries with DATA elements
    metabolite_response <- list(
        list(ID = "1", name = "Metabolite A", DATA = list(value = 10, units = "mg")),
        list(ID = "2", name = "Metabolite B", DATA = list(value = 20, units = "mg"))
    )
    result <- response_to_df(metabolite_response)
    expect_equal(nrow(result), 4)
    expect_true("ID" %in% names(result))
    expect_true("DATA" %in% names(result))
    expect_equal(result$ID, c("1", "1", "2", "2"))

    # Metabolite entries with NULL in DATA
    metabolite_null_response <- list(
        list(ID = "1", name = "Metabolite A", DATA = list(value = NULL, units = "mg")),
        list(ID = "2", name = "Metabolite B", DATA = list(value = 20, units = NULL))
    )
    result <- response_to_df(metabolite_null_response)
    expect_equal(nrow(result), 4)
    expect_true("ID" %in% names(result))
    expect_true("DATA" %in% names(result))
    expect_true(all(is.na(result$DATA$value)))

    # Lists of lists (multiple records)
    list_of_lists_response <- list(
        list(id = 1, name = "A"),
        list(id = 2, name = "B")
    )
    result <- response_to_df(list_of_lists_response)
    expect_equal(nrow(result), 2)
    expect_true("id" %in% names(result))

    expect_type(result, "list")
    # Fallback case (unexpected structure)
    unexpected_response <- list(c("item1", "item2"), c("item3", "item4"))
    expect_error(response_to_df(unexpected_response))
    expect_equal(nrow(result), 2)
})

test_that("response_to_df validates input", {
    expect_error(response_to_df("not_a_list"), "Response must be a list")
    expect_error(response_to_df(123), "Response must be a list")
    expect_error(response_to_df(NULL), "Response must be a list")
})

test_that("parse_mw_output handles valid input correctly", {
    # Valid input: regular tab-delimited string
    result <- paste0(
        "Input m/z\tMatched m/z\tDelta\tName\tSystematic name\tFormula\t",
        "Ion\tCategory\tMain class\tSub class\n",
        "180.063\t180.0634\t.0004\t1,3,4,5,6-Pentahydroxyhexan-2-One\t",
        "1,3,4,5,6-pentahydroxyhexan-2-one\tC6H12O6\tNeutral\tOrganic oxygen ",
        "compounds\tOrganooxygen compounds\tCarbohydrates and carbohydrate ",
        "conjugates"
    )
    result_df <- parse_mw_output(result)
    expect_s3_class(result_df, "tbl_df")
    expect_equal(ncol(result_df), 10) # 10 columns in the header
    expect_equal(result_df$Name[1], "1,3,4,5,6-Pentahydroxyhexan-2-One")

    # Test for extra newlines in the string
    result_with_extra_newlines <- paste0(
        "Input m/z\tMatched m/z\tDelta\tName\tSystematic name\tFormula\t",
        "Ion\tCategory\tMain class\tSub class\n\n",
        "180.063\t180.0634\t.0004\t1,3,4,5,6-Pentahydroxyhexan-2-One\t",
        "1,3,4,5,6-pentahydroxyhexan-2-one\tC6H12O6\tNeutral\tOrganic oxygen ",
        "compounds\tOrganooxygen compounds\tCarbohydrates and carbohydrate ",
        "conjugates\n"
    )
    result_df <- parse_mw_output(result_with_extra_newlines)
    expect_equal(nrow(result_df), 1) # Only one row of data

    # Test for incomplete rows (rows with missing columns)
    incomplete_result <- paste0(
        "Input m/z\tMatched m/z\tDelta\tName\tSystematic name\tFormula\t",
        "Ion\tCategory\tMain class\tSub class\n",
        "180.063\t180.0634\t.0004\t1,3,4,5,6-Pentahydroxyhexan-2-One\t",
        "1,3,4,5,6-pentahydroxyhexan-2-one\tC6H12O6\tNeutral\tOrganic oxygen\n"
    )
    result_df <- parse_mw_output(incomplete_result)
    expect_equal(nrow(result_df), 0) # Incomplete row should be ignored

    # Test for missing column in the header (resulting in an incomplete row)
    missing_header_result <- paste0(
        "Input m/z\tMatched m/z\tDelta\tName\tSystematic name\tFormula\t",
        "Ion\tCategory\tMain class\n", # Missing "Sub class"
        "180.063\t180.0634\t.0004\t1,3,4,5,6-Pentahydroxyhexan-2-One\t",
        "1,3,4,5,6-pentahydroxyhexan-2-one\tC6H12O6\tNeutral\tOrganic oxygen ",
        "compounds\tOrganooxygen compounds\n"
    )
    result_df <- parse_mw_output(missing_header_result)
    expect_equal(ncol(result_df), 9) # Only 9 columns because "Sub class" is missing
})

test_that("parse_mw_output validates input", {
    expect_error(parse_mw_output(123), "Input 'result' must be a character string.")
    expect_error(parse_mw_output(""))
    expect_no_error(parse_mw_output("name,value\n1,2"))
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
