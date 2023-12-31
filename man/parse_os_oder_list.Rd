% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_os_oder_list.R
\name{parse_os_oder_list}
\alias{parse_os_oder_list}
\title{Parse OpenSpecimen Order Item List}
\usage{
parse_os_oder_list(response)
}
\arguments{
\item{response}{Response object from httr::GET \href{https://openspecimen.atlassian.net/wiki/spaces/CAT/pages/259457102/Retrieve+Order+Items}{Link to Api details}}
}
\value{
A data.table containing parsed information from the OpenSpecimen order items.
}
\description{
This function parses a list of OpenSpecimen order items list (distributed samples) and returns a data.table with selected fields.
}
\note{
\href{https://openspecimen.atlassian.net/wiki/spaces/CAT/pages/259457102/Retrieve+Order+Items}{Link to Api details}
}
\examples{

#parse_os_oder_list(oder_items)

}
