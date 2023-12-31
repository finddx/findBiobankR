# WARNING - Generated by {fusen} from dev/biobank_reports.Rmd: do not edit by hand

#' Extract FinDx Study ID
#'
#' This function extracts a study ID from participant or aliquot ID
#'
#' @param x The input string from which to extract the study ID.
#'
#' @return A character vector containing the extracted study ID.
#'
#' @importFrom stringr str_extract str_to_upper
#
#' @export
#' 
#' @examples
#'
#' ppid <- c("TB002133530", "TB032020154",
#'           "TB001200533", "TB001035037", 
#'           "TB002133927")
#' study_id <- get_find_study_id(ppid)
#'
get_find_study_id <- function(x) {
  if (!is.character(x)) {
    stop("Input must be a character vector.")
  }
  study_id <- str_extract(str_to_upper(x), "[A-Z]{2}[0-9]{3}")
  return(study_id)
}
