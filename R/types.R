
#  ------------------------------------------------------------------------
#
# Title : Types
#    By : Jimmy Briggs
#  Date : 2025-02-26
#
#  ------------------------------------------------------------------------

#' Types
#'
#' @name types
#'
#' @description
#' Custom type definitions for the data structures used in the tools.
#'
#' Functions:
#'
#' - `type_gmaps_geocode_address()`: Defines the structure for geocoded address data.
#' - `type_gmaps_place_details()`: Defines the structure for place details data.
#' - `type_clean_address()`: Defines the structure for cleaned address data.
#' - `type_domain_from_url()`: Defines the structure for domain extracted from URL data.
#' - `type_gmaps_results()`: Defines the structure for Google Maps results data.
#'
#' @returns
#' Each function returns an [ellmer::type_object()] definition object.
NULL

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string type_number
type_gmaps_geocode_address <- function() {
  ellmer::type_object(
    status = ellmer::type_string("The status of the API request."),
    formatted_address = ellmer::type_string("The formatted address."),
    place_id = ellmer::type_string("The place ID."),
    place_types = ellmer::type_string("The place types."),
    latitude = ellmer::type_number("The latitude."),
    longitude = ellmer::type_number("The longitude.")
  )
}

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string type_number
type_gmaps_place_details <- function() {
  ellmer::type_object(
    status = ellmer::type_string("The status of the API request."),
    name = ellmer::type_string("The name of the place."),
    formatted_address = ellmer::type_string("The formatted address."),
    place_id = ellmer::type_string("The place ID."),
    place_types = ellmer::type_string("The place types."),
    latitude = ellmer::type_number("The latitude."),
    longitude = ellmer::type_number("The longitude.")
  )
}

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string
type_clean_address <- function() {
  ellmer::type_object(
    address = ellmer::type_string("The cleaned address.")
  )
}

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string
type_domain_from_url <- function() {
  ellmer::type_object(
    domain = ellmer::type_string("The domain extracted from the URL.")
  )
}

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string type_number
type_gmaps_results <- function() {
  ellmer::type_object(
    company_name = ellmer::type_string("The name of the company."),
    company_address_full = ellmer::type_string("The full address of the company."),
    company_website = ellmer::type_string("The website of the company."),
    company_domain = ellmer::type_string("The domain of the company."),
    company_phone = ellmer::type_string("The phone number of the company."),
    gmaps_place_id = ellmer::type_string("The place ID."),
    gmaps_place_types = ellmer::type_string("The place types."),
    latitude = ellmer::type_number("The latitude."),
    longitude = ellmer::type_number("The longitude.")
  )
}
