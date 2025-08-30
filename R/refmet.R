#' Get RefMet information by name
#'
#' Retrieve RefMet (Reference list of Metabolite names) information
#' for a specific metabolite name.
#'
#' @param client An mw_rest_client object
#' @param name Character. RefMet metabolite name
#' @param fields Character. Fields to return (default: "all")
#'
#' @return Tibble containing RefMet information
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#' refmet_info <- get_refmet_by_name(client, "Cholesterol")
#' }
#'
#' @export
get_refmet_by_name <- function(client, name, fields = "all") {
    endpoint <- paste0("refmet/name/", URLencode(name), "/", fields)
    result <- mw_request(client, endpoint)
    response_to_df(result)
}

#' Standardize metabolite name to RefMet
#'
#' Convert a metabolite name to its standardized RefMet equivalent.
#' Useful for name harmonization across datasets.
#'
#' @param client An mw_rest_client object
#' @param name Character. Metabolite name to standardize
#'
#' @return Tibble containing the standardized RefMet name
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#'
#' # Standardize a metabolite name
#' standardized <- standardize_to_refmet(client, "glucose")
#' print(standardized$refmet_name)
#' }
#'
#' @export
standardize_to_refmet <- function(client, name) {
    endpoint <- paste0("refmet/match/", URLencode(name), "/name")
    result <- mw_request(client, endpoint)
    response_to_df(result)
}

#' Get all RefMet names
#'
#' Retrieve the complete list of standardized metabolite names from RefMet.
#' This can be large, so consider using caching.
#'
#' @param client An mw_rest_client object
#'
#' @return Tibble containing all RefMet names
#'
#' @examples
#' \dontrun{
#' # Use caching for this large dataset
#' client <- mw_rest_client(cache = TRUE)
#' all_names <- get_all_refmet_names(client)
#' }
#'
#' @export
get_all_refmet_names <- function(client) {
    endpoint <- "refmet/name"
    result <- mw_request(client, endpoint)
    response_to_df(result)
}
