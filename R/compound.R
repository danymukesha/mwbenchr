#' Get compound information by registry number
#'
#' Retrieve detailed compound information using the Metabolomics Workbench
#' registry number.
#'
#' @param client An mw_rest_client object
#' @param regno Character or numeric. Registry number
#' @param fields Character. Fields to return (default: "all")
#' @param format Character. Output format ("json" or "txt")
#'
#' @return Tibble with compound information (JSON) or character string (txt)
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#'
#' # Get all fields for a compound
#' compound_info <- get_compound_by_regno(client, "1")
#'
#' # Get only the name
#' compound_name <- get_compound_by_regno(client, "1", fields = "name")
#' }
#'
#' @export
get_compound_by_regno <- function(client, regno, fields = "all",
                                  format = "json") {
    endpoint <- paste0("compound/regno/", regno, "/", fields)
    if (format != "json") endpoint <- paste0(endpoint, "/", format)

    result <- mw_request(client, endpoint, format = format)

    if (format == "json") {
        response_to_df(result)
    } else {
        result
    }
}

#' Get compound information by PubChem CID
#'
#' Retrieve detailed compound information using a PubChem Compound ID.
#'
#' @param client An mw_rest_client object
#' @param cid Character or numeric. PubChem CID
#' @param fields Character. Fields to return (default: "all")
#' @param format Character. Output format ("json" or "txt")
#'
#' @return Tibble with compound information (JSON) or character string (txt)
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#' compound_info <- get_compound_by_pubchem_cid(client, "5793")
#' }
#'
#' @export
get_compound_by_pubchem_cid <- function(client, cid, fields = "all",
                                        format = "json") {
    endpoint <- paste0("compound/pubchem_cid/", cid, "/", fields)
    if (format != "json") endpoint <- paste0(endpoint, "/", format)

    result <- mw_request(client, endpoint, format = format)

    if (format == "json") {
        response_to_df(result)
    } else {
        result
    }
}

#' Get compound classification hierarchy
#'
#' Retrieve the taxonomic classification hierarchy for a compound using
#' various identifier types.
#'
#' @param client An mw_rest_client object
#' @param id_type Character. Identifier type ("regno", "pubchem_cid", etc.)
#' @param id_value Character or numeric. Identifier value
#'
#' @return Tibble containing classification hierarchy
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#' classification <- get_compound_classification(client, "regno", "1")
#' }
#'
#' @export
get_compound_classification <- function(client, id_type, id_value) {
    endpoint <- paste0("compound/", id_type, "/", id_value, "/classification")
    result <- mw_request(client, endpoint)
    response_to_df(result)
}

#' Download compound structure file
#'
#' Download molecular structure files in various formats (MOL, SDF, PNG).
#'
#' @param client An mw_rest_client object
#' @param id_type Character. Identifier type ("regno", "pubchem_cid", etc.)
#' @param id_value Character or numeric. Identifier value
#' @param format Character. File format ("molfile", "sdf" or "png")
#' @param save_path Character. Path to save the downloaded file.
#'  If NULL, content is returned as a character string.
#'
#' @return Character string containing the structure file content
#'  or NULL if saved to a file
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#' mol_file <- download_compound_structure(
#'     client, "regno", "1", "molfile",
#'     "compound.mol"
#' )
#'
#' # Save to file
#' }
#'
#' @export
download_compound_structure <- function(client, id_type, id_value,
                                        format = "molfile", save_path = NULL) {
    valid_formats <- c("molfile", "sdf", "png")
    if (!format %in% valid_formats) {
        stop("format must be one of: ", paste(valid_formats, collapse = ", "),
            call. = FALSE
        )
    }

    if (!is.null(save_path)) {
        file_extension <- tools::file_ext(save_path)

        if ((format == "molfile" && file_extension != "mol") ||
            (format == "sdf" && file_extension != "sdf") ||
            (format == "png" && file_extension != "png")) {
            new_save_path <- sub(
                paste0("\\.", file_extension, "$"),
                paste0(".", format), save_path
            )

            warning(
                "The requested format is '", format,
                "', but the file extension was '.", file_extension,
                "'. The extension has been changed to '.", format,
                "' and the file will be saved as ", new_save_path
            )

            save_path <- new_save_path
        }
    }

    endpoint <- paste0("compound/", id_type, "/", id_value, "/", format)
    compound_structure <- mw_request(client, endpoint, format = format)

    if (!is.null(save_path)) {
        if (format == "png" || format == "sdf" || format == "molfile") {
            writeBin(compound_structure, save_path)
        } else {
            writeLines(compound_structure, save_path)
        }
        message("File saved to ", save_path)
        return(NULL)
    }

    return(compound_structure)
}
