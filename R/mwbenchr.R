#' mwbenchr: R Interface to Metabolomics Workbench REST API
#'
#' This package provides functions to interact with the Metabolomics
#' Workbench REST API (v1.2). It supports contexts: study, compound,
#' refmet, metstat, gene, protein, and moverz.
#' @import httr2
#' @import jsonlite
#' @import dplyr
#' @importFrom purrr map list_rbind
#' @import tibble
#' @importFrom methods is
#' @importFrom utils URLencode
#' @name mwbenchr
#' @seealso
#' \itemize{
#'  \item Visit \url{https://www.metabolomicsworkbench.org/tools/mw_rest.php}
#'  for details of the API.
#' }
#' @keywords internal
"_PACKAGE"

NULL
