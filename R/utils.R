#' Flatten a single metabolite entry (with nested DATA field)
#'
#' @param entry A list of metabolite metadata and nested sample data
#' @return A single-row tibble
#' @export
flatten_entry <- function(entry) {
    if (!is.list(entry) || is.null(entry$DATA)) {
        stop("Entry must be a list with a $DATA element")
    }

    meta <- tibble::tibble(
        study_id = entry$study_id,
        analysis_id = entry$analysis_id,
        analysis_summary = entry$analysis_summary,
        metabolite_name = entry$metabolite_name,
        metabolite_id = entry$metabolite_id,
        refmet_name = entry$refmet_name,
        units = entry$units
    )

    sample_data <- tibble::as_tibble(entry$DATA)
    dplyr::bind_cols(meta, sample_data)
}

#' Convert mwbenchr API response into a clean data frame
#'
#' Handles responses like:
#'
#' - Flat named list (e.g. compound, study)
#' - Named list of rows (e.g. search results from search_metstat)
#' - List of metabolite entries (with nested DATA)
#'
#' @param response A parsed response from mwbenchr
#' @return A tibble
#' @export
response_to_df <- function(response) {
    if (!is.list(response)) {
        stop("Response must be a list (e.g., from JSON or mwbenchr API)")
    }

    if (!is.null(names(response)) && all(grepl("^Row\\d+$", names(response)))) {
        return(
            purrr::map(response, tibble::as_tibble) |>
                purrr::list_rbind(names_to = "row")
        )
    }

    if (all(purrr::map_lgl(response, ~ is.list(.x) && "DATA" %in% names(.x)))) {
        return(
            purrr::map(response, flatten_entry) |>
                purrr::list_rbind()
        )
    }

    if (!is.null(names(response)) && all(nzchar(names(response))) &&
        !any(grepl("^\\d+$", names(response)))) {
        return(tibble::as_tibble(response))
    }

    if (all(purrr::map_lgl(response, is.list))) {
        return(
            purrr::map(response, tibble::as_tibble) |>
                purrr::list_rbind()
        )
    }

    tibble::as_tibble(response)
}


#' Print available endpoints
#'
#' @param client mwREST client
#' @return Information about available endpoints
#' @export
list_endpoints <- function(client) {
    cat("Available endpoints in mwREST package:\n")
    cat("1. Compound endpoints:\n")
    cat("   - get_compound_by_regno()\n")
    cat("   - get_compound_by_pubchem_cid()\n")
    cat("   - get_compound_classification()\n")
    cat("   - download_compound_structure()\n\n")

    cat("2. Study endpoints:\n")
    cat("   - get_study_summary()\n")
    cat("   - get_study_factors()\n")
    cat("   - get_study_metabolites()\n")
    cat("   - get_study_data()\n\n")

    cat("3. RefMet endpoints:\n")
    cat("   - get_refmet_by_name()\n")
    cat("   - standardize_to_refmet()\n")
    cat("   - get_all_refmet_names()\n\n")

    cat("4. MetStat endpoints:\n")
    cat("   - search_metstat()\n\n")

    cat("5. Mass spec endpoints:\n")
    cat("   - search_by_mass()\n")
    cat("   - calculate_exact_mass()\n")
}
