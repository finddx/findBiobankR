% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_bulk_order_items.R
\name{get_bulk_order_items}
\alias{get_bulk_order_items}
\title{Retrieve Order Items for Multiple Orders}
\usage{
get_bulk_order_items(auth_response, orders_ids, ...)
}
\arguments{
\item{auth_response}{Authentication response obtained from the OpenSpecimen API.}

\item{orders_ids}{Vector of integers representing the IDs of the orders to retrieve items for.}

\item{...}{Additional parameters to be passed to \code{get_order_items} function.}
}
\value{
A data.table containing the retrieved order items.
}
\description{
This function retrieves order items for multiple orders specified by their IDs.
}
\examples{
\dontrun{
auth_response <- auth_os(url, username, password)
orders_data <- get_bulk_order_items(auth_response, c(1, 2, 3))
}

#get_bulk_order_items()
}
