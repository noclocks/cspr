% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hunter.R
\name{hunter_get_company_domain}
\alias{hunter_get_company_domain}
\title{Get Company Domain via Hunter.io}
\usage{
hunter_get_company_domain(company_name, api_key = get_hunterio_api_key())
}
\arguments{
\item{company_name}{Character string representing the name of the company.}

\item{api_key}{Hunter.io API key. If not provided, uses \code{\link[=get_hunterio_api_key]{get_hunterio_api_key()}} to retrieve it.}
}
\value{
A character string representing the domain of the company. If no domain is found, returns \code{NA}.
}
\description{
This function retrieves the domain of a company based on its name using the Hunter.io API.
}
