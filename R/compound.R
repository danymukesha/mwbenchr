#' Get compound information by registry number
#'
#' @param client mwREST client
#' @param regno Registry number
#' @param fields Fields to return (default: "all")
#' @param format Output format ("json" or "txt")
#' @return Compound information
#' @export
get_compound_by_regno <- function(client, regno,
                                  fields = "all",
                                  format = "json") {
    endpoint <- paste0("compound/regno/", regno, "/", fields)
    if (format != "json") endpoint <- paste0(endpoint, "/", format)
    mw_request(client, endpoint, format = format)
}

#' Get compound information by PubChem CID
#'
#' @param client mwREST client
#' @param cid PubChem CID
#' @param fields Fields to return (default: "all")
#' @param format Output format ("json" or "txt")
#' @return Compound information
#' @export
get_compound_by_pubchem_cid <- function(client, cid,
                                        fields = "all",
                                        format = "json") {
    endpoint <- paste0("compound/pubchem_cid/", cid, "/", fields)
    if (format != "json") endpoint <- paste0(endpoint, "/", format)
    mw_request(client, endpoint, format = format)
}

#' Get compound classification by identifier
#'
#' @param client mwREST client
#' @param id_type Identifier type ("regno", "pubchem_cid", etc.)
#' @param id_value Identifier value
#' @return Classification hierarchy
#' @export
get_compound_classification <- function(client,
                                        id_type,
                                        id_value) {
    endpoint <- paste0("compound/", id_type, "/", id_value, "/classification")
    mw_request(client, endpoint)
}

#' Download compound structure file
#'
#' @param client mwREST client
#' @param id_type Identifier type ("regno", "pubchem_cid", etc.)
#' @param id_value Identifier value
#' @param format File format ("molfile" or "sdf")
#' @return File content
#' @export
download_compound_structure <- function(client,
                                        id_type,
                                        id_value, format = "molfile") {
    endpoint <- paste0("compound/", id_type, "/", id_value, "/", format)
    mw_request(client, endpoint, parse = FALSE) |>
        httr2::resp_body_string()
}
