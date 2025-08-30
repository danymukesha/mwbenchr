# Contributing to `mwbenchr`

We're excited to have you contribute to `mwbenchr`! This document outlines how you can get involved and contribute to the project.

For more detailed guidance on contributing to `mwbenchr` and other tidyverse packages, check out the [development contributing guide](https://rstd.io/tidy-contrib) and our [code review principles](https://code-review.tidyverse.org/).

## Ways you can contribute

### Bug Reports

-   If you've encountered a bug, please let us know by opening an issue.
-   Provide a minimal reproducible example, so we can quickly see the issue.
-   Mention your R version, the package version, and your operating system.
-   If possible, include the full error message and traceback.

### Feature Requests

-   Want to see a new feature? Open an issue and let's discuss it.
-   Be sure to explain how the feature will be used and why it's important.
-   Think about whether it fits within the scope of the package before suggesting.

### Code Contributions

-   Fork the repository and create a new branch for your changes.
-   Follow the coding style guidelines we've set out below.
-   Add tests for any new functionality you create.
-   Update the documentation where necessary.
-   Open a pull request with a clear description of the changes you've made.

## Setting up your development environment

1.  **Fork the repo and clone it to your local machine:**

    ``` bash
    git clone https://github.com/danymukesha/mwbenchr.git
    cd mwbenchr
    ```

2.  **Install all the necessary development dependencies:**

    ``` r
    # 1st, install devtools if you haven't already
    install.packages("devtools")

    # 2nd, install the package dependencies
    devtools::install_deps(dependencies = TRUE)

    # 3rd, install additional development tools like testthat and BiocCheck
    install.packages(c("testthat", "covr", "BiocCheck"))
    ```

3.  **Load the package and run tests:**

    ``` r
    # load the package for development purposes
    devtools::load_all()

    # run the tests
    devtools::test()

    # Check the package
    devtools::check()
    ```

## Coding Guidelines

### R Code Style

-   We follow the [Bioconductor coding style](https://bioconductor.org/developers/how-to/coding-style/).
-   Use `snake_case` for function names and variable names.
-   Keep line lengths under 80 characters for readability.
-   Use clear, meaningful names for functions and variables.
-   Add type checks for function parameters where appropriate.

### Documentation

-   We use `roxygen2` for documentation, so be sure to include `@param`, `@return`, and `@examples` in your functions.
-   Include working examples in the `@examples` section (use `\dontrun{}` for API calls).
-   Update vignettes if you're adding significant new features.

### Testing

-   Write tests for new functions using `testthat`.
-   We aim for over 80% code coverage, so write tests for both success and error cases.
-   If your code makes API calls, use mocking in your tests.
-   Tests should go in the `tests/testthat/` folder.

### Version Control

-   When working on a new feature, create a branch off of `main`: `git checkout -b feature/new-feature`.
-   Write clear, descriptive commit messages.
-   Keep commits focused and as small as possible.
-   Reference any relevant issues in your commit messages.

## Pull Request Process

Before submitting your pull request, please make sure:

1.  **You've done all the necessary checks:**

    -   Run `devtools::check()` and fix any warnings or errors.
    -   Run `BiocCheck::BiocCheck()` to catch any Bioconductor-specific issues.
    -   Make sure all tests pass by running `devtools::test()`.
    -   Update `NEWS.md` if you've added features or fixed bugs.
    -   Don't forget to update documentation if necessary.

2.  **When submitting the pull request:**

    -   Provide a clear description of what's changed.
    -   Link to any relevant issues.
    -   Include tests for new functionality.
    -   Ensure the code is properly covered by tests.
    -   Make sure all continuous integration checks pass.

3.  **Review process:**

    -   Maintainers will review your PR and may ask for changes.
    -   Once your PR is approved, it will be merged.

## Testing Guidelines

### Unit Tests

Here's a basic structure for testing a function:

``` r
test_that("function validates input correctly", {
  expect_error(my_function("invalid_input"), "helpful error message")
  expect_equal(my_function("valid_input"), expected_result)
})
```

### Mocking API Calls

If your function makes API calls, here's how you can mock them in tests:

``` r
test_that("API function constructs correct endpoint", {
  mock_request <- function(client, endpoint, ...) {
    list(endpoint = endpoint)
  }
  
  with_mocked_bindings(
    mw_request = mock_request,
    {
      result <- my_api_function(client, "param")
      expect_match(result$endpoint, "expected/endpoint/param")
    }
  )
})
```

## Documentation Guidelines

### Function Documentation Template

Use this format for documenting your functions:

``` r
#' Brief description of what the function does
#'
#' A more detailed explanation of how the function works, when to use it,
#' and any important considerations.
#'
#' @param param1 Description of the first parameter
#' @param param2 Description of the second parameter
#'
#' @return What this function returns
#'
#' @examples
#' \dontrun{
#' # Example of how to use the function
#' result <- my_function("example")
#' print(result)
#' }
#'
#' @export
```

### Vignette Updates

-   Add new sections in the vignette if you've introduced significant features.
-   Make sure examples in the vignette have working code and expected output.
-   Update existing examples if they are impacted by API changes.
-   Ensure the vignette compiles without errors.

## Release Process

### Version Numbers

-   We follow [Semantic Versioning](https://semver.org/), so be sure to update the version number in the `DESCRIPTION` file accordingly.
-   Keep track of changes in `NEWS.md`.

### Bioconductor Requirements

-   Ensure the package passes `R CMD check --as-cran`.
-   Address any warnings or errors reported by `BiocCheck`.
