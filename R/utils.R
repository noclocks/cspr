
#  ------------------------------------------------------------------------
#
# Title : General Utilities
#    By : Jimmy Briggs
#  Date : 2025-02-25
#
#  ------------------------------------------------------------------------

#' Package System File
#'
#' @description
#' Get the path to a system file within the package.
#'
#' @param ... Additional arguments passed to `system.file()`.
#'
#' @returns
#' A character string representing the path to the system file.
#'
#' @export
#'
#' @examples
#' pkg_sys("config/config.yml")
pkg_sys <- function(...) {
  system.file(..., package = "cspr")
}

#' Get Full Address
#'
#' @description
#' Combine the address, city, state, and zip code components into a single string.
#'
#' @param address A character string representing the street address.
#' @param city A character string representing the city name.
#' @param state A character string representing the state abbreviation.
#' @param zip A character string representing the zip code.
#'
#' @returns
#' A character string representing the full address.
#'
#' @export
#'
#' @importFrom stringr str_c
get_full_address <- function(address, city, state, zip) {
  stringr::str_c(
    clean_address(address),
    city,
    state,
    zip,
    sep = ", "
  )
}

#' Clean Address
#'
#' @description
#' Cleanse and format an address in a standardized manner by removing unnecessary
#' elements and characters and combining the address, city, state, and zip code
#' components into a single string.
#'
#' @param address A character string representing the street address.
#'
#' @returns
#' A character string representing the cleansed and formatted address.
#'
#' @export
#'
#' @importFrom stringr str_trim str_replace_all str_extract str_detect
clean_address <- function(address) {

  address |>
    stringr::str_replace_all("#\\s*\\d+", "") |>
    stringr::str_replace_all("\\s+", " ") |>
    stringr::str_trim()

}

#' Validate Address Format
#'
#' @description
#' Validate the format of a street address by checking if it is in the expected
#' format with the street number and name.
#'
#' @param address A character string with the address string to validate.
#'
#' @returns
#' List with two elements: `valid` (logical) and `address` (character).
#'
#' @export
#'
#' @importFrom stringr str_detect
validate_address <- function(address) {

  has_number <- stringr::str_detect(address, "^\\d+\\s+\\w+")
  has_street <- stringr::str_detect(
    address,
    "\\s(St|Street|Ave|Avenue|Blvd|Boulevard|Dr|Drive|Rd|Road|Ln|Lane|Way|Pkwy|Parkway|Cir|Circle|Ct|Court|Pl|Place|Ter|Terrace)"
  )

  if (!has_number || !has_street) {
    return(
      list(
        valid = FALSE,
        address = address
      )
    )
  }

  list(
    valid = TRUE,
    address = address
  )

}

#' Get Domain from URL
#'
#' @description
#' Extract the domain from a URL string by removing the protocol and any sub-domains.
#'
#' @param url A character string representing the URL to extract the domain from.
#'
#' @returns
#' A character string representing the domain extracted from the URL.
#'
#' @export
#'
#' @importFrom stringr str_replace_all str_extract
get_domain_from_url <- function(url) {
  url |>
    stringr::str_replace_all("https?://(www\\.)?", "") |>
    stringr::str_extract("^[^/]+")
}
