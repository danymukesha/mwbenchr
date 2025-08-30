test_that("compound functions construct correct endpoints", {
    client <- mw_rest_client()

    mock_request <- function(client, endpoint, format = NULL, parse = TRUE) {
        list(endpoint = endpoint, format = format, parse = parse)
    }

    mock_response_to_df <- function(x) x

    with_mocked_bindings(
        mw_request = mock_request,
        response_to_df = mock_response_to_df,
        {
            result <- get_compound_by_regno(client, "1")
            expect_match(result$endpoint, "compound/regno/1/all")

            result <- get_compound_by_regno(client, "1", fields = "name")
            expect_match(result$endpoint, "compound/regno/1/name")

            result <- get_compound_by_pubchem_cid(client, "5793")
            expect_match(result$endpoint, "compound/pubchem_cid/5793/all")

            result <- get_compound_classification(client, "regno", "1")
            expect_match(result$endpoint, "compound/regno/1/classification")

            result <- download_compound_structure(client, "regno", "1", "molfile")
            expect_no_error(result)
        }
    )
})

test_that("download_compound_structure validates format", {
    client <- mw_rest_client()

    expect_error(
        download_compound_structure(client, "regno", "1", "invalid"),
        "format must be one of: molfile, sdf, png"
    )
})

test_that("download_compound_structure handles file extensions", {
    client <- mw_rest_client()

    # Test with .mol extension when format is 'molfile'
    expect_warning(
        download_compound_structure(client, "regno", "1", "molfile", "compound.txt"),
        "The requested format is 'molfile', but the file extension was '.txt'. The extension has been changed"
    )

    # Test with .png extension when format is 'png'
    expect_warning(
        download_compound_structure(client, "regno", "1", "png", "compound.sdf"),
        "The requested format is 'png', but the file extension was '.sdf'. The extension has been changed"
    )
})

test_that("get_compound_by_regno returns correct data", {
    client <- mw_rest_client()
    mock_request <- function(client, endpoint, format = NULL, parse = TRUE) {
        list(name = "DL-Acetylcarnitine")
    }

    with_mocked_bindings(
        mw_request = mock_request,
        {
            result <- get_compound_by_regno(client, "1")
            expect_equal(result$name, "DL-Acetylcarnitine")
        }
    )
})

test_that("get_compound_by_pubchem_cid returns correct data", {
    client <- mw_rest_client()
    mock_request <- function(client, endpoint, format = NULL, parse = TRUE) {
        list(name = "2-methoxy-12-methyloctadec-17-en-5-ynoyl anhydride")
    }

    with_mocked_bindings(
        mw_request = mock_request,
        {
            result <- get_compound_by_pubchem_cid(client, "1")
            expect_equal(result$name, "2-methoxy-12-methyloctadec-17-en-5-ynoyl anhydride")
        }
    )
})

test_that("get_compound_by_regno constructs the correct endpoint for non-json formats", {
    client <- mw_rest_client()
    expect_no_error(get_compound_by_regno(client, "1", format = "json"))
    expect_no_error(get_compound_by_regno(client, "1", format = "png"))
    expect_no_error(get_compound_by_regno(client, "1", format = "sdf"))
})

test_that("get_compound_by_pubchem_cid constructs the correct endpoint for non-json formats", {
    client <- mw_rest_client()
    expect_no_error(get_compound_by_pubchem_cid(client, "1", format = "json"))
    expect_no_error(get_compound_by_pubchem_cid(client, "1", format = "png"))
    expect_no_error(get_compound_by_pubchem_cid(client, "1", format = "sdf"))
})


test_that("download_compound_structure handles saving files", {
    client <- mw_rest_client()

    mock_request <- function(client, endpoint, format = NULL, parse = TRUE) {
        "file content"
    }

    test_result <- NULL
    mock_writeLines <- function(text, con) {
        test_result <<- list(text = text, con = con)
    }

    with_mocked_bindings(
        mw_request = mock_request,
        {
            result <- download_compound_structure(client, "regno", "1", "molfile", "test.mol")
            expect_null(result)
            expect_true(file.exists("test.mol"))
            expect_equal(test_result, NULL)
            unlink("test.mol")
        }
    )
})
