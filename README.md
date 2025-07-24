
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mwbenchr

<!-- badges: start -->

<!-- badges: end -->

Our mission:

- **To cover all REST API endpoints** provided by the Metabolomics
  Workbench.
- **To ensure type safety** through strict validation of inputs and
  outputs.
- **To deliver tidy outputs** as well-structured `data.frame`s ready for
  analysis.
- **To support efficient workflows** with optional local caching of API
  responses.
- **To respect API rate limits** with built-in request throttling and
  retry logic.
- **To enhance user experience** with clear and informative API
  messages.

Use-case:

``` r
## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----initialize---------------------------------------------------------------
library(mwbenchr)
client <- mw_rest_client()

## ----compound-----------------------------------------------------------------
# Get compound information by PubChem CID
compound <- get_compound_by_pubchem_cid(client, 5281365)
head(compound)
#> $pubchem_cid
#> [1] "5281365"
#> 
#> $regno
#> [1] "28467"
#> 
#> $formula
#> [1] "C20H34O"
#> 
#> $exactmass
#> [1] "290.260966"
#> 
#> $inchi_key
#> [1] "OJISWRZIEWCUBN-QIRCYJPOSA-N"
#> 
#> $name
#> [1] "Geranylgeraniol"

## ----study--------------------------------------------------------------------
# Get study summary
study <- get_study_summary(client, "ST000001")
head(study)
#> $study_id
#> [1] "ST000001"
#> 
#> $study_title
#> [1] "Fatb Induction Experiment (FatBIE)"
#> 
#> $species
#> [1] "Arabidopsis thaliana"
#> 
#> $institute
#> [1] "University of California, Davis"
#> 
#> $analysis_type
#> [1] "GC-MS"
#> 
#> $number_of_samples
#> [1] "24"

## ----metstat------------------------------------------------------------------
# Search for diabetes studies in human blood
diabetes_studies <- search_metstat(
  client,
  species = "Human",
  sample_source = "Blood",
  disease = "Diabetes"
)
head(diabetes_studies)
#> $Row1
#> $Row1$study
#> [1] "ST003671"
#> 
#> $Row1$study_title
#> [1] "Discovery of Metabolic Biomarkers for Gestational Diabetes Mellitus: An In-Depth Metabolomics Investigation Utilizing Mass Spectrometry  "
#> 
#> $Row1$species
#> [1] "Human"
#> 
#> $Row1$source
#> [1] "Blood"
#> 
#> $Row1$disease
#> [1] "Diabetes"
#> 
#> 
#> $Row2
#> $Row2$study
#> [1] "ST003390"
#> 
#> $Row2$study_title
#> [1] "In-depth profiling of biosignatures for Type 2 diabetes mellitus cohort utilizing an integrated targeted LC-MS platform"
#> 
#> $Row2$species
#> [1] "Human"
#> 
#> $Row2$source
#> [1] "Blood"
#> 
#> $Row2$disease
#> [1] "Diabetes"
#> 
#> 
#> $Row3
#> $Row3$study
#> [1] "ST002681"
#> 
#> $Row3$study_title
#> [1] "Non-T2D vs T2D"
#> 
#> $Row3$species
#> [1] "Human"
#> 
#> $Row3$source
#> [1] "Blood"
#> 
#> $Row3$disease
#> [1] "Diabetes"
#> 
#> 
#> $Row4
#> $Row4$study
#> [1] "ST002496"
#> 
#> $Row4$study_title
#> [1] "Study of environmental toxicants and gut microbiome in relation to obesity and insulin resistance"
#> 
#> $Row4$species
#> [1] "Human"
#> 
#> $Row4$source
#> [1] "Blood"
#> 
#> $Row4$disease
#> [1] "Diabetes"
#> 
#> 
#> $Row5
#> $Row5$study
#> [1] "ST001991"
#> 
#> $Row5$study_title
#> [1] "Dynamics of bile acid metabolism between the host and gut microbiome in progression to islet autoimmunity (Blood)"
#> 
#> $Row5$species
#> [1] "Human"
#> 
#> $Row5$source
#> [1] "Blood"
#> 
#> $Row5$disease
#> [1] "Diabetes"
#> 
#> 
#> $Row6
#> $Row6$study
#> [1] "ST001948"
#> 
#> $Row6$study_title
#> [1] "Metabolites Associated with Gestational Diabetes in Plasma"
#> 
#> $Row6$species
#> [1] "Human"
#> 
#> $Row6$source
#> [1] "Blood"
#> 
#> $Row6$disease
#> [1] "Diabetes"
```
