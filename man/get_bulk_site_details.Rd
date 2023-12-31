% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_bulk_site_details.R
\name{get_bulk_site_details}
\alias{get_bulk_site_details}
\title{Get Bulk Site Details}
\usage{
get_bulk_site_details(auth_response, site_ids, ...)
}
\arguments{
\item{auth_response}{The authentication response object.}

\item{site_ids}{A vector of integers representing the IDs of the sites to retrieve details for.}

\item{...}{Additional parameters to be passed to the underlying \code{get_os_site} function.}
}
\value{
A data table containing the details of the requested sites.
}
\description{
Use this function to retrieve details of multiple sites in bulk from the OpenSpecimen application.
}
\examples{
#get_bulk_site_details()
}
