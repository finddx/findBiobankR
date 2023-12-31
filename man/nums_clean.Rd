% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nums_clean.R
\name{nums_clean}
\alias{nums_clean}
\title{Clean Numeric Values}
\usage{
nums_clean(x)
}
\arguments{
\item{x}{A character vector containing numeric values with potential commas and dashes.}
}
\value{
A numeric vector after cleaning the input values.
}
\description{
Use this function to clean numeric values from Excel (.xlsx) or Salesforce report date,
where missing values are presented with a dash ("-").
}
\details{
The function removes commas and dashes from the input character vector and converts
it to a numeric vector.
}
\examples{
x <- c("1,000", "2,000", "3,000", "4,000",
      "5,000", "-", "7,000",
      "8,000","-", "10,000")

nums_clean(x)
}
