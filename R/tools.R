
#  ------------------------------------------------------------------------
#
# Title : Tools
#    By : Jimmy Briggs
#  Date : 2025-02-26
#
#  ------------------------------------------------------------------------

#' Tools
#'
#' @name tools
#'
#' @description
#' Register various tools for geocoding, address cleaning, and domain extraction.
#'
#' Functions:
#'
#' - `tool_gmaps_places_search()`: Search for places using Google Maps Places API to find website and
#'   contact information.
#' - `tool_hunter_get_email_address()`: Retrieve an email address based on the provided company domain, company name,
#'   and person's first and last name using the Hunter.io API.
#'
#' @returns
#' Each function returns an [ellmer::tool()] definition object.
NULL

#' @rdname tools
#' @export
#' @importFrom ellmer tool type_string type_number type_object
tool_gmaps_places_search <- function() {

  ellmer::tool(
    .name = "gmaps_places_search",
    .description = "Search for places using Google Maps Places API to find website and contact information",
    .fun = gmaps_places_search,
    company_name = ellmer::type_string(
      "The name of the company to search for.",
      required = TRUE
    ),
    company_address = ellmer::type_string(
      "The address of the company to search for.",
      required = TRUE
    ),
    company_phone = ellmer::type_string(
      "The phone number of the company to search for. Default is `NULL`.",
      required = FALSE
    )
  )

}

#' @rdname tools
#' @export
#' @importFrom ellmer tool type_string type_number type_object
tool_hunter_get_email_address <- function() {

  ellmer::tool(
    .name = "hunter_get_email_address",
    .description = "Retrieve an email address based on the provided company domain, company name, and person's first and last name using the Hunter.io API.",
    .fun = hunter_get_email_address,
    company_domain = ellmer::type_string(
      "The company domain to search for.",
      required = TRUE
    ),
    company_name = ellmer::type_string(
      "The company name to search for.",
      required = TRUE
    ),
    first_name = ellmer::type_string(
      "The person's first name to search for.",
      required = TRUE
    ),
    last_name = ellmer::type_string(
      "The person's last name to search for.",
      required = TRUE
    )
  )

}
