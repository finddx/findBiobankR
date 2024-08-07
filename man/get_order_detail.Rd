% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_order_detail.R
\name{get_order_detail}
\alias{get_order_detail}
\title{Get OpenSpecimen Order Detail}
\usage{
get_order_detail(auth_response, order_id, return_numeric = F)
}
\arguments{
\item{auth_response}{The authentication response obtained from \code{auth_os}.}

\item{order_id}{The ID of the order to retrieve details for.}

\item{return_numeric}{Logical, whether to return timestamps as numeric values (default is TRUE). This function is parsed to parse order detail function}
}
\value{
A data table containing the parsed order detail data.
}
\description{
This function retrieves details of a specific order from the OpenSpecimen API using the provided authentication response and order ID.
}
\examples{
# extract order 392 from os

# df = get_order_detail(auth_response, order_id = 392)

}
