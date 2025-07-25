% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/client.R
\name{mw_rest_client}
\alias{mw_rest_client}
\title{Initialization of the Metabolomics Workbench REST client}
\usage{
mw_rest_client(
  base_url = "https://www.metabolomicsworkbench.org/rest",
  cache = FALSE,
  cache_dir = tempdir(),
  timeout = 30
)
}
\arguments{
\item{base_url}{Base URL for the API (defaults to production)}

\item{cache}{Should responses be cached? (TRUE/FALSE)}

\item{cache_dir}{Directory for cached responses}

\item{timeout}{Request timeout in seconds}
}
\value{
An mwREST client object
}
\description{
Initialization of the Metabolomics Workbench REST client
}
