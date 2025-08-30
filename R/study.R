#' Get study summary information
#'
#' Retrieve summary information for one or all studies in the Metabolomics
#' Workbench database.
#'
#' @param client An mw_rest_client object
#' @param study_id Character. Study ID (use "ST" for all studies)
#' @param format Character. Output format ("json" or "txt")
#'
#' @return Study summary data as tibble (JSON) or character string (txt)
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#'
#' # Get all studies
#' all_studies <- get_study_summary(client)
#'
#' # Get specific study
#' study_info <- get_study_summary(client, study_id = "ST000001")
#' }
#'
#' @export
get_study_summary <- function(client, study_id = "ST", format = "json") {
    endpoint <- paste0("study/study_id/", study_id, "/summary")
    if (format != "json") endpoint <- paste0(endpoint, "/", format)

    result <- mw_request(client, endpoint, format = format)

    if (format == "json") {
        response_to_df(result)
    } else {
        result
    }
}

#' Get study experimental factors
#'
#' Retrieve the experimental factors (sample metadata) for a specific study.
#'
#' @param client An mw_rest_client object
#' @param study_id Character. Study ID
#'
#' @return Tibble containing experimental factors
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#' factors <- get_study_factors(client, "ST000001")
#' }
#'
#' @export
get_study_factors <- function(client, study_id) {
    endpoint <- paste0("study/study_id/", study_id, "/factors")
    result <- mw_request(client, endpoint)
    response_to_df(result)
}

#' Get study metabolite list
#'
#' Retrieve the list of metabolites measured in a specific study.
#'
#' @param client An mw_rest_client object
#' @param study_id Character. Study ID
#'
#' @return Tibble containing metabolite information
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#' metabolites <- get_study_metabolites(client, "ST000001")
#' }
#'
#' @export
get_study_metabolites <- function(client, study_id) {
    endpoint <- paste0("study/study_id/", study_id, "/metabolites")
    result <- mw_request(client, endpoint)
    response_to_df(result)
}

#' Get study data matrix
#'
#' Retrieve the complete data matrix for a specific study, including
#' metabolite measurements across all samples.
#'
#' @param client An mw_rest_client object
#' @param study_id Character. Study ID
#'
#' @return Tibble containing the study data matrix
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#' data_matrix <- get_study_data(client, "ST000001")
#' }
#'
#' @export
get_study_data <- function(client, study_id) {
    endpoint <- paste0("study/study_id/", study_id, "/data")
    result <- mw_request(client, endpoint)
    response_to_df(result)
}
