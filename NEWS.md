# mwbenchr 0.0.1

## New Features

### Initial Release

-   **Client Management**: Implemented REST client with configurable caching, timeouts, and error handling
-   **Study Access**: Complete suite of functions for accessing study data, metadata, and experimental factors
-   **Compound Information**: Retrieve detailed compound data using registry numbers, PubChem CIDs, and classifications
-   **RefMet Integration**: Full support for RefMet standardized metabolite nomenclature
-   **Mass Spectrometry Tools**: Search compounds by accurate mass and calculate exact masses for lipids
-   **Advanced Search**: MetStat integration for multi-criteria study searches
-   **Data Processing**: Intelligent response parsing with support for different API response formats

### Core Functions

-   `mw_rest_client()`: Initialize API client with configuration options
-   `get_study_summary()`, `get_study_factors()`, `get_study_metabolites()`, `get_study_data()`: Study data access
-   `get_compound_by_regno()`, `get_compound_by_pubchem_cid()`, `get_compound_classification()`: Compound information
-   `get_refmet_by_name()`, `standardize_to_refmet()`, `get_all_refmet_names()`: RefMet integration\
-   `search_metstat()`: Multi-criteria study search
-   `search_by_mass()`, `calculate_exact_mass()`: Mass spectrometry tools
-   `response_to_df()`, `flatten_entry()`: Data processing utilities

### Package Infrastructure

-   **Documentation**: Detailed function documentation with examples
-   **Vignette**: Complete tutorial with real-world workflows
-   **Testing**: Full test suite with \>90% code coverage
-   **Bioconductor**: Compliant with Bioconductor standards and guidelines
-   **Error Handling**: Robust error messages and automatic retry logic
-   **Performance**: Built-in caching and rate limiting support

## Technical Details

-   **Dependencies**: R packages (httr2, tibble, dplyr, purrr)
-   **Compatibility**: R \>= 4.3.0, all major platforms
-   **API Version**: Metabolomics Workbench REST API v1.2
-   **Data Format**: Returns tidy data frames (tibbles) for easy analysis
