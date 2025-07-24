#' Search compounds by mass
#'
#' @param client mwREST client
#' @param db Database ("MB", "LIPIDS", or "REFMET")
#' @param mz Mass-to-charge ratio
#' @param ion_type Ion type (e.g., "M+H", "M-H")
#' @param tolerance Mass tolerance in Daltons
#' @param format Output format ("json" or "txt")
#' @return Matching compounds
#' @export
search_by_mass <- function(client, db, mz, ion_type, tolerance, format = "json") {
    endpoint <- paste0("moverz/", db, "/", mz, "/", ion_type, "/", tolerance)
    if (format != "json") endpoint <- paste0(endpoint, "/", format)
    mw_request(client, endpoint, format = format)
}

#' Calculate exact mass
#'
#' @param client mwREST client
#' @param lipid_abbrev Lipid abbreviation (e.g., "PC(34:1)")
#' @param ion_type Ion type (e.g., "M+H")
#' @return Exact mass
#' @export
calculate_exact_mass <- function(client, lipid_abbrev, ion_type) {
    endpoint <- paste0("moverz/exactmass/", lipid_abbrev, "/", ion_type)
    mw_request(client, endpoint)
}
