#' Search studies using MetStat criteria
#'
#' @param client mwREST client
#' @param analysis_type Analysis type (e.g., "LCMS", "GCMS")
#' @param polarity Polarity (e.g., "POSITIVE", "NEGATIVE")
#' @param chromatography Chromatography method (e.g., "HILIC", "RP")
#' @param species Species (e.g., "Human", "Mouse")
#' @param sample_source Sample source (e.g., "Blood", "Urine")
#' @param disease Disease association (e.g., "Diabetes")
#' @param kegg_id KEGG ID (e.g., "C00002")
#' @param refmet_name RefMet name (e.g., "Cholesterol")
#' @return Matching studies
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
    # Construct semicolon-delimited query
    query <- paste(
        analysis_type, polarity, chromatography, species,
        sample_source, disease, kegg_id, refmet_name,
        sep = ";"
    )

    endpoint <- paste0("metstat/", query)
    mw_request(client, endpoint)
}
