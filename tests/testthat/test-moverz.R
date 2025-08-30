test_that("search_by_mass validates database parameter", {
    client <- mw_rest_client()

    expect_error(
        search_by_mass(client, "INVALID", 180, "M+H", 0.01),
        "db must be one of: MB, LIPIDS, REFMET"
    )
    expect_no_error(
        search_by_mass(client, "REFMET", 180, "M+H", 0.01,
            format = "invalid"
        )
    )
})

test_that("search_by_mass validates numeric parameters", {
    client <- mw_rest_client()

    expect_error(
        search_by_mass(client, "REFMET", "not_numeric", "M+H", 0.01),
        "mz must be numeric"
    )

    expect_error(
        search_by_mass(client, "REFMET", 180, "M+H", -0.01),
        "tolerance must be numeric and positive"
    )

    expect_error(
        search_by_mass(client, "REFMET", 180, "M+H", "not_numeric"),
        "tolerance must be numeric and positive"
    )
})

test_that("search_by_mass constructs correct multiple lines of tab-separated values", {
    client <- mw_rest_client()

    mock_request <- function(client, endpoint, format = NULL, parse = TRUE) {
        return("Input m/z\tMatched m/z\tDelta\tName\tSystematic name\tFormula\tIon\tCategory\tMain class\tSub class\n
                180.063\t180.063\t0.0004\t1D-chiro-Inositol\tC6H12O6\tNeutral\tOrganic\tAlcohols\tInositols\n
                180.063\t180.063\t0.0004\tAllose\tC6H12O6\tNeutral\tOrganic\tOrganooxygen\tInositols")
    }

    with_mocked_bindings(
        mw_request = mock_request,
        {
            result <- search_by_mass(client, "REFMET", 180.063, "M+H", 0.01)
            expect_equal(
                colnames(result),
                c(
                    "Input m/z", "Matched m/z", "Delta", "Name",
                    "Systematic name", "Formula", "Ion", "Category",
                    "Main class", "Sub class"
                )
            )
        }
    )
})

test_that("calculate_exact_mass validates parameters", {
    client <- mw_rest_client()

    expect_error(
        calculate_exact_mass(client, "PC(34:1)", ion_type = 123)
    )
})

test_that("calculate_exact_mass works correctly", {
    client <- mw_rest_client()
    result <- calculate_exact_mass(client, "PC(34:1)", "M+H")
    expect_equal(result$lipid_abbrev, "PC(34:1)")
    expect_equal(result$ion_type, "M+H")
    expect_equal(result$lipid_name, "PC 34:1")
    expect_equal(result$ion_type_parsed, "[M+H]+")
    expect_equal(result$mz, 760.585077)
    expect_equal(result$formula, "C42H83NO8P")
})

test_that("calculate_exact_mass handles invalid response", {
    client <- mw_rest_client()

    mock_request <- function(client, endpoint) {
        "PC 34:1\nM+H"
    }

    with_mocked_bindings(
        mw_request = mock_request,
        {
            expect_error(
                calculate_exact_mass(client, "PC(34:1)", "M+H"),
                "The response format is incorrect or incomplete."
            )
        }
    )
})
