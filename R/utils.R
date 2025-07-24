#' Convert API response to data frame
#'
#' @param response API response
#' @return Data frame
#' @export
response_to_df <- function(response) {
    if (!is.list(response)) {
        stop("Response must be a list (JSON parsed response)")
    }

    # we handle different response structures
    if (all(c("data", "columns") %in% names(response))) {
        # the espected study data response
        df <- as.data.frame(do.call(rbind, response$data))
        colnames(df) <- response$columns
    } else if (is.null(names(response))) {
        # obtained list of compounds
        df <- do.call(rbind, lapply(response, as.data.frame))
    } else {
        # otherwise single item
        df <- as.data.frame(response)
    }

    df
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
