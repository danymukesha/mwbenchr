#' mwbenchr: R Interface to Metabolomics Workbench REST API
#'
#' This package provides functions to interact with the Metabolomics
#' Workbench REST API (v1.2). It supports contexts: study, compound,
#' RefMet, MetStat, gene, protein, and moverz.
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
#' @import ggplot2
#' @name mwbenchr-package
#' @aliases mwbenchr
#' @seealso \url{https://www.metabolomicsworkbench.org/tools/mw_rest.php}
#' @keywords package
"_PACKAGE"
