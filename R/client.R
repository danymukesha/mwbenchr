#' Initialization of the Metabolomics Workbench REST client
#'
#' @param base_url Base URL for the API (defaults to production)
#' @param cache Should responses be cached? (TRUE/FALSE)
#' @param cache_dir Directory for cached responses
#' @param timeout Request timeout in seconds
#' @return An mwREST client object
#' @export
mw_rest_client <- function(base_url = "https://www.metabolomicsworkbench.org/rest",
                           cache = FALSE,
                           cache_dir = tempdir(),
                           timeout = 30) {
    stopifnot(is.character(base_url), length(base_url) == 1)
    stopifnot(is.logical(cache), length(cache) == 1)
    stopifnot(is.character(cache_dir), length(cache_dir) == 1)
    stopifnot(is.numeric(timeout), length(timeout) == 1, timeout > 0)

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
#' @param client mwREST client object
#' @param endpoint API endpoint path (e.g., "compound/regno/11/name")
#' @param parse Should the response be parsed? (TRUE/FALSE)
#' @param format Output format ("json" or "txt")
#' @param ... Additional parameters passed to httr2::req_perform
#' @return API response
#' @keywords internal
mw_request <- function(client, endpoint, parse = TRUE, format = "json", ...) {
    stopifnot(inherits(client, "mw_rest_client"))

    url <- paste0(client$base_url, "/", endpoint)

    req <- httr2::request(url) |>
        httr2::req_timeout(client$timeout) |>
        httr2::req_user_agent("mwREST R package (https://github.com/yourusername/mwREST)")

    if (client$cache) {
        req <- req |>
            httr2::req_cache(tempdir = client$cache_dir)
    }

    resp <- tryCatch(
        req |> httr2::req_perform(...),
        error = function(e) {
            stop("API request failed: ", e$message)
        }
    )

    if (parse) {
        if (format == "json") {
            resp <- httr2::resp_body_json(resp)
        } else {
            resp <- httr2::resp_body_string(resp)
        }
    }

    resp
}
