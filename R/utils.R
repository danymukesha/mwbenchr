#' Flatten a metabolite entry with nested sample data
#'
#' Converts a single metabolite entry containing metadata and nested DATA field
#' into a flat tibble structure suitable for analysis.
#'
#' @param entry List. A metabolite entry with metadata and DATA field
#'
#' @return A tibble with flattened metabolite and sample data
#'
#' @examples
#' \dontrun{
#' entry <- list(
#'     study_id = "ST001",
#'     metabolite_name = "Glucose",
#'     DATA = data.frame(sample1 = 100, sample2 = 150)
#' )
#' flatten_entry(entry)
#' }
#'
#' @export
flatten_entry <- function(entry) {
    if (!is.list(entry) || is.null(entry$DATA)) {
        stop("Entry must be a list with a DATA element", call. = FALSE)
    }

    meta <- tibble(
        study_id = entry$study_id %||% NA_character_,
        analysis_id = entry$analysis_id %||% NA_character_,
        analysis_summary = entry$analysis_summary %||% NA_character_,
        metabolite_name = entry$metabolite_name %||% NA_character_,
        metabolite_id = entry$metabolite_id %||% NA_character_,
        refmet_name = entry$refmet_name %||% NA_character_,
        units = entry$units %||% NA_character_
    )

    sample_data <- as_tibble(entry$DATA)
    bind_cols(meta, sample_data)
}

#' Convert Response to Data Frame
#'
#' This function converts a complex list-based response (from an API or
#' other source)
#' into a `tibble`. It handles different types of list structures, including
#' flat responses,
#' search results (with rows), and metabolite entries with `DATA` values.
#'
#' @param response A list that can be in various forms:
#' - Flat named list (single record)
#' - Search results with rows (e.g., `Row1`, `Row2`)
#' - Metabolite entries with `DATA` elements (e.g., measurement data)
#'
#' @return A `tibble` with the processed data, where each element is converted
#'  into a column.
#'   If `DATA` columns are `NULL`, they are replaced with `NA`.
#'
#' @export
response_to_df <- function(response) {
    if (!is.list(response)) {
        stop("Response must be a list", call. = FALSE)
    }

    if (length(response) == 0) {
        return(tibble())
    }

    # Handle named lists with Row pattern (search results)
    if (!is.null(names(response)) && all(grepl("^Row\\d+$", names(response)))) {
        return(
            map(response, function(x) {
                # Replace NULL values with NA before converting to tibble
                x <- modifyList(x, lapply(x, function(val) {
                    if (is.null(val)) NA else val
                }))
                as_tibble(x)
            }) |>
                list_rbind(names_to = "row_id")
        )
    }

    # Handle lists with DATA elements (metabolite entries)
    if (all(map_lgl(response, ~ is.list(.x) && "DATA" %in% names(.x)))) {
        return(
            map(response, function(x) {
                # Replace NULLs in DATA elements with NA
                x$DATA <- lapply(x$DATA, function(val) {
                    if (is.null(val)) NA else val
                })
                as_tibble(x)
            }) |>
                list_rbind()
        )
    }

    # Handle flat named lists (single record)
    if (!is.null(names(response)) &&
        all(nzchar(names(response))) &&
        !any(grepl("^\\d+$", names(response)))) {
        return(as_tibble(response))
    }

    # Handle lists of lists (multiple records)
    if (all(map_lgl(response, is.list))) {
        return(
            map(response, function(x) {
                # Replace NULL values with NA before converting to tibble
                x <- modifyList(x, lapply(x, function(val) {
                    if (is.null(val)) NA else val
                }))
                as_tibble(x)
            }) |>
                list_rbind()
        )
    }

    # Fallback
    as_tibble(response)
}

#' Parse a tab-delimited string into a data frame
#'
#' This function parses a tab-delimited string containing chemical data and
#' converts it into a data frame. The string contains columns such as "Input
#' m/z", "Matched m/z", "Delta", "Name", "Systematic name", "Formula", "Ion",
#' "Category", "Main class", and "Sub class".
#'
#' @param result A character string, typically the output of a `mw_request()`
#'   function that returns a tab-delimited string.
#'
#' @return A data frame where each row represents a set of chemical data parsed
#'   from the input string. The columns include "Input m/z", "Matched m/z",
#'   "Delta", "Name", "Systematic name", "Formula", "Ion", "Category", "Main
#'   class", and "Sub class".
#'
#' @examples
#' result <- paste0(
#'     "Input m/z\tMatched m/z\tDelta\tName\tSystematic name\tFormula\t",
#'     "Ion\tCategory\tMain class\tSub class\n",
#'     "180.063\t180.0634\t.0004\t1,3,4,5,6-Pentahydroxyhexan-2-One\t",
#'     "1,3,4,5,6-pentahydroxyhexan-2-one\tC6H12O6\tNeutral\tOrganic oxygen ",
#'     "compounds\tOrganooxygen compounds\tCarbohydrates and carbohydrate ",
#'     "conjugates"
#' )
#' parsed_data <- parse_mw_output(result)
#' print(parsed_data)
#'
#' @importFrom vroom vroom
#' @importFrom dplyr as_tibble
#'
#' @export
parse_mw_output <- function(result) {
    if (!is.character(result)) {
        stop("Input 'result' must be a character string.")
    }
    lines <- strsplit(result, "\n")[[1]]
    lines <- lines[lines != ""]

    header <- lines[1]
    data_lines <- lines[-1]

    max_columns <- length(strsplit(header, "\t")[[1]])
    data_lines_filtered <- data_lines[sapply(data_lines, function(x) {
        length(strsplit(x, "\t")[[1]]) == max_columns
    })]

    parsed_data <- vroom::vroom(I(paste(data_lines_filtered, collapse = "\n")),
        col_names = strsplit(header, "\t")[[1]],
        delim = "\t",
        show_col_types = FALSE
    )
    dplyr::as_tibble(parsed_data)
}

#' List available API endpoints
#'
#' Display information about available endpoints in the mwbenchr package
#' organized by functional category.
#'
#' @param client An mw_rest_client object (used for method dispatch)
#'
#' @return Invisibly returns NULL (called for side effects)
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#' list_endpoints(client)
#' }
#'
#' @export
list_endpoints <- function(client) {
    cat("Metabolomics Workbench REST API Endpoints\n")
    cat("=========================================\n\n")

    cat("1. Compound Functions:\n")
    cat("   get_compound_by_regno()        - Get compound by registry number\n")
    cat("   get_compound_by_pubchem_cid()  - Get compound by PubChem CID\n")
    cat("   get_compound_classification()  - Get compound classification\n")
    cat("   download_compound_structure()  - Download structure files\n\n")

    cat("2. Study Functions:\n")
    cat("   get_study_summary()            - Get study metadata\n")
    cat("   get_study_factors()            - Get experimental factors\n")
    cat("   get_study_metabolites()        - Get study metabolite list\n")
    cat("   get_study_data()               - Get study data matrix\n\n")

    cat("3. RefMet Functions:\n")
    cat("   get_refmet_by_name()           - Get RefMet information\n")
    cat("   standardize_to_refmet()        - Standardize metabolite names\n")
    cat("   get_all_refmet_names()         - Get all RefMet names\n\n")

    cat("4. Search Functions:\n")
    cat("   search_metstat()               - Search studies by criteria\n")
    cat("   search_by_mass()               - Search compounds by mass\n")
    cat("   calculate_exact_mass()         - Calculate exact masses\n\n")

    cat("Use ?function_name for detailed help on any function.\n")
    invisible(NULL)
}

# Utility function for handling NULL values
`%||%` <- function(x, y) if (is.null(x)) y else x
