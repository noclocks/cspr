
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

#' Clean Company Name
#'
#' @description
#' Cleanse and format a company name by removing common suffixes and
#' non-alphanumeric characters, and converting it to lowercase.
#'
#' @param company_name Character string representing the company name to be cleaned.
#'
#' @returns
#' A character string representing the cleansed and formatted company name.
#'
#' @export
#'
#' @importFrom stringr str_replace_all str_trim
clean_company_name <- function(company_name) {
  company_name |>
    tolower() |>
    stringr::str_replace_all("(inc\\.?|llc|corp\\.?|corporation|investment|holdings)", "") |>
    stringr::str_replace_all("[^a-z0-9]", "") |>
    stringr::str_trim()
}

#' Clean First and Last Name
#'
#' @description
#' Cleanse and format a first and last name by removing any trailing initials.
#'
#' @param first_name Character string representing the first name to be cleaned.
#' @param last_name Character string representing the last name to be cleaned.
#'
#' @returns
#' A character string representing the cleansed and formatted full name.
#'
#' @export
#'
#' @importFrom stringr str_replace_all str_trim
clean_first_last_name <- function(first_name, last_name) {

  first_name <- stringr::str_replace_all(first_name, "\\s*\\w+\\.$", "")

  paste0(
    stringr::str_trim(first_name),
    " ",
    stringr::str_trim(last_name)
  ) |>
    stringr::str_replace_all("\\s+", " ")

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

#' Calculate String Similarity
#'
#' @description
#' Calculate the similarity between two strings using the Jaro-Winkler distance method.
#'
#' @param string1 A character string representing the first string.
#' @param string2 A character string representing the second string.
#'
#' @returns
#' A numeric value between 0 and 1 representing the similarity between the two strings.
#'
#' @export
#'
#' @importFrom stringdist stringdist
string_similarity <- function(string1, string2) {
  string1 <- tolower(string1)
  string2 <- tolower(string2)
  1 - (stringdist::stringdist(string1, string2, method = "jw") / max(nchar(string1), nchar(string2)))
}

# checks ----------------------------------------------------------------------------------------------------------

check_inherits <- function(x, class, x_arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!inherits(x, class)) {
    cli::cli_abort(
      "{.arg {x_arg}} must inherit from class {.cls {class}}, not {.obj_type_friendly {x}}.",
      call = call
    )
  }
  invisible(NULL)
}

check_installed <- function(pkg, call = rlang::caller_env()) {
  if (!is_installed(x)) {
    cli::cli_abort("Package {.pkg {pkg}} is not installed.", call = call)
  }
  invisible(NULL)
}

check_chat <- function(chat, arg = rlang::caller_arg(chat), call = rlang::caller_env()) {
  check_inherits(chat, "Chat", x_arg = arg, call = call)
  invisible(NULL)
}

check_tool <- function(tool, arg = rlang::caller_arg(tool), call = rlang::caller_env()) {
  check_inherits(tool, "ellmer::ToolDef", x_arg = arg, call = call)
  invisible(NULL)
}

check_row <- function(row, arg = rlang::caller_arg(row), call = rlang::caller_env()) {
  check_inherits(row, "data.frame", x_arg = arg, call = call)
  if (nrow(row) != 1) {
    cli::cli_abort("{.arg {arg}} must be a single-row data frame.", call = call)
  }
  invisible(NULL)
}

