#' Initialize Metabolomics Workbench REST client
#'
#' Create a client object for interacting with the Metabolomics Workbench
#' REST API.
#' The client handles configuration for base URL, caching, and request
#' timeouts.
#'
#' @param base_url Character. Base URL for the API (defaults to production
#' endpoint)
#' @param cache Logical. Should responses be cached? (default: FALSE)
#' @param cache_dir Character. Directory for cached responses (default:
#' tempdir())
#' @param timeout Numeric. Request timeout in seconds (default: 30)
#'
#' @return An S3 object of class "mw_rest_client"
#'
#' @examples
#' \dontrun{
#' # Create a client with default settings
#' client <- mw_rest_client()
#'
#' # Create a client with caching enabled
#' client <- mw_rest_client(cache = TRUE)
#'
#' # Create a client with custom timeout
#' client <- mw_rest_client(timeout = 60)
#' }
#'
#' @export
mw_rest_client <- function(base_url =
                               "https://www.metabolomicsworkbench.org/rest",
                           cache = FALSE,
                           cache_dir = tempdir(),
                           timeout = 30) {
    stopifnot(
        "base_url must be a character string" =
            is.character(base_url) && length(base_url) == 1,
        "cache must be logical" =
            is.logical(cache) && length(cache) == 1,
        "cache_dir must be a character string" =
            is.character(cache_dir) && length(cache_dir) == 1,
        "timeout must be a positive number" =
            is.numeric(timeout) && length(timeout) == 1 && timeout > 0
    )

    structure(
        list(
            base_url = base_url,
            cache = cache,
            cache_dir = cache_dir,
            timeout = timeout
        ),
        class = "mw_rest_client"
    )
}

#' Make a request to the Metabolomics Workbench REST API
#'
#' Internal function to handle HTTP requests to the API with error handling
#' and response parsing.
#'
#' @param client An mw_rest_client object
#' @param endpoint Character. API endpoint path
#' @param parse Logical. Should the response be parsed? (default: TRUE)
#' @param format Character. Output format ("json" or "txt")
#' @param ... Additional parameters passed to httr2::req_perform
#'
#' @return Parsed API response (list for JSON, character for text)
#' @keywords internal
mw_request <- function(client, endpoint, parse = TRUE, format = NULL, ...) {
    stopifnot(
        "client must be an mw_rest_client object" =
            inherits(client, "mw_rest_client")
    )

    url <- file.path(client$base_url, endpoint)

    req <- request(url) |>
        req_timeout(client$timeout) |>
        req_user_agent(paste0("mwbenchr R package ",
            "(https://github.com/danymukesha/mwbenchr)",
            sep = ""
        )) |>
        req_retry(max_tries = 3, backoff = ~ runif(1, min = 1, max = 3))

    if (client$cache) {
        req <- req |> req_cache(path = client$cache_dir)
    }

    resp <- tryCatch(
        req_perform(req, ...),
        error = function(e) {
            stop("API request failed for endpoint '", endpoint, "': ",
                e$message,
                call. = FALSE
            )
        }
    )

    content_type <- resp_content_type(resp)

    if (is.null(format)) {
        format <-
            if (grepl("json", content_type, ignore.case = TRUE)) {
                "json"
            } else {
                "txt"
            }
    }

    if (!parse) {
        return(resp)
    }

    switch(format,
        "json" = resp_body_json(resp),
        "txt" = resp_body_string(resp),
        "png" = resp_body_raw(resp),
        resp_body_string(resp)
    )
}

#' Print method for mw_rest_client
#' @param x An mw_rest_client object
#' @param ... Additional arguments (not used)
#' @export
print.mw_rest_client <- function(x, ...) {
    cat("Metabolomics Workbench REST Client\n")
    cat("  Base URL:", x$base_url, "\n")
    cat("  Caching:", if (x$cache) "Enabled" else "Disabled", "\n")
    cat("  Timeout:", x$timeout, "seconds\n")
    if (x$cache) {
        cat("  Cache directory:", x$cache_dir, "\n")
    }
}
