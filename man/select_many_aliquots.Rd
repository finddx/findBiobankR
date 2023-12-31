% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/select_many_aliquots.R
\name{select_many_aliquots}
\alias{select_many_aliquots}
\title{Title Select many aliquots}
\usage{
select_many_aliquots(x, aliquots)
}
\arguments{
\item{x}{A list of lists containing aliquot labels.}

\item{aliquots}{The number of aliquots to select.}
}
\value{
A list of vectors, each containing the selected aliquot labels.
}
\description{
Description Selects multiple aliquots labels from a list of lists.
}
\examples{

samples_list <- list(c("TB0990100010101001", "TB0990100010101002", "TB0990100010101003"),
                     c("TB0990100020101001", "TB0990100020101002", "TB0990100020101003"), 
                     c("TB0990100030101001", "TB0990100030101002", "TB0990100030101003"),
                     c("TB0990100040101001", "TB0990100040101002", "TB0990100040101003"),
                     c("TB0990100050101001", "TB0990100050101002", "TB0990100050101003"
                     ))

## Select two aliquots per patient
aliquots_selected <- select_many_aliquots(samples_list, 
                                          aliquots = 2)

aliquots_selected
}
