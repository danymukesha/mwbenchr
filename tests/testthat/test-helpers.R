test_that("construct_url handles invalid context", {
    expect_error(
        construct_url("invalid", "input", "value", "output"),
        "Invalid context"
    )
})

test_that("construct_url handles metstat with incorrect input length", {
    expect_error(
        construct_url("metstat", "", c("a", "b"), ""),
        "metstat context requires exactly 8 input values"
    )
})

test_that("construct_url handles valid metstat input", {
    BASE_URL <- NULL
    BASE_URL <<- "https://www.example.com/"
    input <- rep("x", 8)
    url <- construct_url("metstat", "", input, "")
    expect_true(grepl("metstat/x;x;x;x;x;x;x;x", url))
})

test_that("construct_url handles moverz exactmass with invalid length", {
    expect_error(
        construct_url("moverz", "exactmass", c("PC(34:1)"), ""),
        "moverz exactmass requires lipid abbreviation and adduct"
    )
})

test_that("construct_url handles moverz with wrong input length", {
    expect_error(
        construct_url("moverz", "search", c(100), ""),
        "moverz requires m/z, ion type, and tolerance"
    )
})

test_that("construct_url handles moverz exactmass correctly", {
    BASE_URL <- NULL
    BASE_URL <<- "https://www.example.com/"
    url <- construct_url("moverz", "exactmass", c("PC(34:1)", "M+H"), "", NULL)
    pattern <- "moverz/exactmass/PC\\(34:1\\)/M\\+H"
    expect_true(grepl(pattern, url))
})

test_that("construct_url handles moverz search with format", {
    BASE_URL <<- "https://www.example.com/"
    url <- construct_url("moverz", "search", c(100, "M+H", 0.01), "", "txt")
    expect_true(grepl("moverz/search/100/M\\+H/0\\.01/txt", url))
})

test_that("construct_url handles default context", {
    BASE_URL <- NULL
    BASE_URL <<- "https://www.example.com/"
    url <- construct_url("compound", "regno", "123", "all")
    expect_true(grepl("compound/regno/123/all", url))
})

test_that("construct_url appends output_format correctly", {
    BASE_URL <- NULL
    BASE_URL <<- "https://www.example.com/"
    url <- construct_url("compound", "regno", "123", "all", "json")
    expect_true(grepl("compound/regno/123/all/json", url))
})
