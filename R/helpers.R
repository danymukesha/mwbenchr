# fx to construct REST URL
construct_url <- function(context, input_item, input_value, output_item,
                          output_format = NULL) {
    if (!context %in% c(
        "study", "compound", "refmet", "metstat", "gene",
        "protein", "moverz"
    )) {
        stop("Invalid context. Must be one of: study, compound, refmet,
             metstat, gene, protein, moverz")
    }

    if (context == "metstat") {
        if (length(input_value) != 8) {
            stop("metstat context requires exactly 8 input values
                 (use empty strings for unused slots)")
        }
        input_str <- paste(input_value, collapse = ";")
        url <- paste0(BASE_URL, context, "/", input_str)
        return(URLencode(url))
    }

    if (context == "moverz") {
        if (input_item == "exactmass") {
            if (length(input_value) != 2) {
                stop("moverz exactmass requires lipid abbreviation and adduct")
            }
            url <- paste0(
                BASE_URL, context, "/", input_item, "/",
                input_value[1], "/", input_value[2]
            )
        } else {
            if (length(input_value) != 3) {
                stop("moverz requires m/z, ion type, and tolerance")
            }
            url <- paste0(
                BASE_URL, context, "/", input_item, "/",
                input_value[1], "/", input_value[2], "/",
                input_value[3]
            )
        }
        if (!is.null(output_format)) {
            url <- paste0(url, "/", output_format)
        }
        return(URLencode(url))
    }

    url <- paste0(
        BASE_URL, context, "/", input_item, "/", input_value, "/",
        output_item
    )
    if (!is.null(output_format)) {
        url <- paste0(url, "/", output_format)
    }
    URLencode(url)
}

# fx to perform API request
perform_request <- function(url, output_format = "json") {
    req <- httr2::request(url) |>
        httr2::req_user_agent("mwbenchr R package (v0.1.0)") |>
        httr2::req_retry(max_tries = 3)

    resp <- tryCatch(
        httr2::req_perform(req),
        error = function(e) stop("API request failed: ", e$message)
    )

    if (output_format == "txt") {
        content <- httr2::resp_body_string(resp)
        return(content)
    } else if (output_format == "png") {
        content <- httr2::resp_body_raw(resp)
        return(content)
    } else {
        content <- httr2::resp_body_json(resp)
        return(jsonlite::fromJSON(jsonlite::toJSON(content), flatten = TRUE))
    }
}
