#' mwbenchr: R Interface for Direct Access to Metabolomics Workbench REST API
#'
#' The **mwbenchr** package enables programmatic retrieval and processing
#' of metabolomics data through the Metabolomics Workbench REST API (v1.2).
#' It provides access to study metadata, compound information,
#' RefMet standardized metabolite names, metabolomics statistics (MetStat),
#' gene and protein data, and pathway mappings (moverz), facilitating
#' reproducible workflows and data integration for metabolomics research.
#'
#' @section Main Functions:
#' \describe{
#'   \item{\code{\link{mw_rest_client}}}{Initialize REST client}
#'   \item{\code{\link{get_study_summary}}}{Get study information}
#'   \item{\code{\link{get_compound_by_regno}}}{Get compound data}
#'   \item{\code{\link{search_metstat}}}{Search studies by criteria}
#'   \item{\code{\link{get_refmet_by_name}}}{Get RefMet standardized names}
#' }
#'
#' @importFrom httr2 request req_timeout req_user_agent req_cache req_perform
#'   req_retry resp_content_type resp_body_json resp_body_string resp_body_raw
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr bind_cols
#' @importFrom purrr map list_rbind map_lgl
#' @importFrom tibble tibble as_tibble
#' @importFrom methods is
#' @importFrom utils URLencode
#' @importFrom sessioninfo session_info
#' @import ggplot2
#' @name mwbenchr
#' @aliases mwbenchr
#' @seealso \url{https://www.metabolomicsworkbench.org/tools/mw_rest.php}
#' @docType package
#' @keywords package
"_PACKAGE"
