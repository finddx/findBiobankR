# WARNING - Generated by {fusen} from dev/biobank_reports.Rmd: do not edit by hand


#' Get the aliquot number from a aliquot ID.
#'
#' This function extracts the aliquot number from a aliquot ID.
#'
#' @param x A character vector representing aliquot IDs.
#'
#' @return A character vector of aliquot numbers. If the input does not have 16 characters, returns NA with a warning.
#'
#' @importFrom stringr str_sub
#'
#' @export
#' @examples
#'
#' get_aliquot_number("PP0070199910001001")
#'
#'

get_aliquot_number <- function(x) {
  if (!is.character(x)) {
    stop("Input must be a character vector.")
  }
  
  if (any(nchar(x) != 18)) {
    
    warning("Some IDS are not in standard FindDX aliquot ID.")

  }
  
  aliquot_number <- str_sub(x, 16, 18)
  
  return(aliquot_number)
}

