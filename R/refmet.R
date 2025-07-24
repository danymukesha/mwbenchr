#' Get RefMet information by name
#'
#' @param client mwREST client
#' @param name RefMet name
#' @param fields Fields to return (default: "all")
#' @return RefMet information
#' @export
get_refmet_by_name <- function(client, name, fields = "all") {
    endpoint <- paste0("refmet/name/", name, "/", fields)
    mw_request(client, endpoint)
}

#' Standardize metabolite name to RefMet
#'
#' @param client mwREST client
#' @param name Metabolite name to standardize
#' @return Standardized RefMet name
#' @export
standardize_to_refmet <- function(client, name) {
    endpoint <- paste0("refmet/match/", name, "/name")
    mw_request(client, endpoint)
}

#' Get all RefMet names
#'
#' @param client mwREST client
#' @return All RefMet names
#' @export
get_all_refmet_names <- function(client) {
    endpoint <- "refmet/name"
    mw_request(client, endpoint)
}
