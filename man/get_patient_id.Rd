% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_patient_id.R
\name{get_patient_id}
\alias{get_patient_id}
\title{Extract Patient ID from FindDX Aliquot ID}
\usage{
get_patient_id(x)
}
\arguments{
\item{x}{A character vector of FindDX Aliquot IDs.}
}
\value{
A character vector of extracted Patient IDs.
}
\description{
This function extracts the Patient ID from FindDX Aliquot IDs.
}
\examples{

get_patient_id("PP0070199910001001")

}
