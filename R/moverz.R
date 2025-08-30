#' Search compounds by mass
#'
#' Search for compounds in specified databases using mass-to-charge ratio,
#' ion type, and mass tolerance.
#'
#' @param client An mw_rest_client object
#' @param db Character. Database to search ("MB", "LIPIDS", or "REFMET")
#' @param mz Numeric. Mass-to-charge ratio
#' @param ion_type Character. Ion type (e.g., "M+H", "M-H", "M+Na")
#' @param tolerance Numeric. Mass tolerance in Daltons
#' @param format Character. Output format ("json" or "txt")
#'
#' @return Tibble containing matching compounds(JSON) or character string(txt)
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#'
#' # Search for compounds with specific m/z
#' matches <- search_by_mass(client,
#'     db = "REFMET",
#'     mz = 180.063,
#'     ion_type = "M+H",
#'     tolerance = 0.01
#' )
#'
#' # Search in lipids database
#' lipid_matches <- search_by_mass(client,
#'     db = "LIPIDS",
#'     mz = 760.585,
#'     ion_type = "M+H",
#'     tolerance = 0.05
#' )
#' }
#'
#' @export
search_by_mass <- function(client, db, mz, ion_type, tolerance,
                           format = "application/json") {
    valid_dbs <- c("MB", "LIPIDS", "REFMET")
    if (!db %in% valid_dbs) {
        stop("db must be one of: ", paste(valid_dbs, collapse = ", "),
            call. = FALSE
        )
    }

    stopifnot(
        "mz must be numeric" = is.numeric(mz),
        "tolerance must be numeric and positive" = is.numeric(tolerance) &&
            tolerance > 0
    )

    endpoint <- paste0(
        "moverz/", db, "/", mz, "/",
        URLencode(ion_type), "/", tolerance
    )
    if (format != "json") {
        endpoint <- paste0(endpoint, "/", format)
    }
    result <- mw_request(client, endpoint, format = "application/json")

    if (format == "application/json") {
        parse_mw_output(result)
    } else {
        result
    }
}

#' Calculate exact mass for lipid
#'
#' Calculate the exact mass for a lipid given its abbreviation and ion type.
#'
#' @param client An mw_rest_client object
#' @param lipid_abbrev A character string representing the lipid abbreviation
#' (e.g., "PC(34:1)", , "PE(36:2)").
#' @param ion_type  A character string representing the ion type
#' (e.g., "M+H", "M-H", "M+Na").
#'
#' @return A `tibble` containing the parsed data, with calculated exact mass:
#'   \describe{
#'     \item{lipid_abbrev}{The lipid abbreviation (e.g., "PC(34:1)")}
#'     \item{ion_type}{The ion type (e.g., "M+H+")}
#'     \item{lipid_name}{The full lipid name (e.g., "PC 34:1")}
#'     \item{ion_type_parsed}{The parsed ion type (e.g., "M+H+")}
#'     \item{mz}{The m/z value (numeric, e.g., 760.585077)}
#'     \item{formula}{The molecular formula (e.g., "C42H83NO8P")}
#'   }
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#'
#' # Calculate exact mass for phosphatidylcholine
#' mass_info <- calculate_exact_mass(client, "PC(34:1)", "M+H")
#' print(mass_info$exactmass)
#'
#' # Calculate for different ion types
#' mass_na <- calculate_exact_mass(client, "PC(34:1)", "M+Na")
#' }
#'
#' @export
calculate_exact_mass <- function(client, lipid_abbrev, ion_type) {
    endpoint <- paste0(
        "moverz/exactmass/",
        URLencode(lipid_abbrev), "/",
        URLencode(ion_type)
    )

    result <- mw_request(client, endpoint)
    # cat("RAW RESULT:\n", result, "\n")
    clean_result <- gsub("\n", "", result)
    clean_result <- gsub("</br>", "\n", clean_result)
    # clean_result <- gsub("<.*?>", "", clean_result)

    components <- strsplit(clean_result, "\n")[[1]]

    components <- components[components != ""]

    if (length(components) < 4) {
        stop("The response format is incorrect or incomplete.")
    }

    lipid_name <- components[1]
    ion_type_parsed <- components[2]
    m_z <- as.numeric(components[3])
    formula <- components[4]

    parsed_data <- tibble(
        lipid_abbrev = lipid_abbrev,
        ion_type = ion_type,
        lipid_name = lipid_name,
        ion_type_parsed = ion_type_parsed,
        mz = m_z,
        formula = formula
    )

    parsed_data
}
