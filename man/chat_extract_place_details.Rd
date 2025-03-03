% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chat.R
\name{chat_extract_place_details}
\alias{chat_extract_place_details}
\title{Extract Place Details}
\usage{
chat_extract_place_details(
  chat,
  company_name,
  company_address,
  company_phone = NULL
)
}
\arguments{
\item{chat}{An \code{ellmer::chat} object.}

\item{company_name}{A character string representing the name of the company.}

\item{company_address}{A character string representing the address of the company.}

\item{company_phone}{A character string representing the phone number of the company.}
}
\value{
A list containing the place details information.
}
\description{
Extract the place details from the chat response.
}
