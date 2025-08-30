#' Search studies using MetStat criteria
#'
#' Search for studies in the Metabolomics Workbench database using multiple
#' criteria including analysis type, species, sample source, and disease.
#'
#' @param client An mw_rest_client object
#' @param analysis_type Character. Analysis type (e.g., "LCMS", "GCMS", "NMR")
#' @param polarity Character. Ionization polarity ("POSITIVE", "NEGATIVE")
#' @param chromatography Character. Chromatography method (e.g., "HILIC", "RP")
#' @param species Character. Species name (e.g., "Human", "Mouse", "Rat")
#' @param sample_source Character. Sample type (e.g., "Blood", "Urine",
#' "Tissue")
#' @param disease Character. Disease or condition
#' @param kegg_id Character. KEGG compound ID (e.g., "C00002")
#' @param refmet_name Character. RefMet standardized metabolite name
#'
#' @return Tibble containing matching studies with metadata
#'
#' @examples
#' \dontrun{
#' client <- mw_rest_client()
#'
#' # Search for human blood LCMS studies
#' studies <- search_metstat(client,
#'     analysis_type = "LCMS",
#'     species = "Human",
#'     sample_source = "Blood"
#' )
#'
#' # Search for diabetes-related studies
#' diabetes_studies <- search_metstat(client, disease = "Diabetes")
#'
#' # Search for studies containing specific metabolite
#' glucose_studies <- search_metstat(client, refmet_name = "Glucose")
#'
#' #' # Search for human blood studies
#' human_blood <- search_metstat(client,
#'     species = "Human",
#'     sample_source = "Blood"
#' )
#' }
#'
#' @export
search_metstat <- function(client,
                           analysis_type = "",
                           polarity = "",
                           chromatography = "",
                           species = "",
                           sample_source = "",
                           disease = "",
                           kegg_id = "",
                           refmet_name = "") {
    # Construct semicolon-delimited query string
    query_parts <- c(
        analysis_type, polarity, chromatography, species,
        sample_source, disease, kegg_id, refmet_name
    )

    query <- paste(query_parts, collapse = ";")
    endpoint <- paste0("metstat/", URLencode(query))

    result <- mw_request(client, endpoint)
    response_to_df(result)
}
