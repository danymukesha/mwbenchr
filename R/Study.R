#' Get study summary
#'
#' @param client mwREST client
#' @param study_id Study ID (use "ST" for all studies)
#' @param format Output format ("json" or "txt")
#' @return Study summary
#' @export
get_study_summary <- function(client,
                              study_id = "ST",
                              format = "json") {
    endpoint <- paste0("study/study_id/", study_id, "/summary")
    if (format != "json") endpoint <- paste0(endpoint, "/", format)
    mw_request(client, endpoint, format = format)
}

#' Get study factors
#'
#' @param client mwREST client
#' @param study_id Study ID
#' @return Study factors
#' @export
get_study_factors <- function(client,
                              study_id) {
    endpoint <- paste0("study/study_id/", study_id, "/factors")
    mw_request(client, endpoint)
}

#' Get study metabolites
#'
#' @param client mwREST client
#' @param study_id Study ID
#' @return Metabolites in study
#' @export
get_study_metabolites <- function(client,
                                  study_id) {
    endpoint <- paste0("study/study_id/", study_id, "/metabolites")
    mw_request(client, endpoint)
}

#' Get study data
#'
#' @param client mwREST client
#' @param study_id Study ID
#' @return Study data
#' @export
get_study_data <- function(client,
                           study_id) {
    endpoint <- paste0("study/study_id/", study_id, "/data")
    mw_request(client, endpoint)
}
