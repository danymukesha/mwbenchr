% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compound.R
\name{get_compound_classification}
\alias{get_compound_classification}
\title{Get compound classification by identifier}
\usage{
get_compound_classification(client, id_type, id_value)
}
\arguments{
\item{client}{mwREST client}

\item{id_type}{Identifier type ("regno", "pubchem_cid", etc.)}

\item{id_value}{Identifier value}
}
\value{
Classification hierarchy
}
\description{
Get compound classification by identifier
}
