
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
#' @importFrom ellmer type_object type_string type_number type_array
type_owner_contact <- function() {

  ellmer::type_object(
    .description = "The contact information for a property owner.",
    owner_name = ellmer::type_string("The name of the property owner."),
    owner_email = ellmer::type_string("The email address of the property owner."),
    owner_phone = ellmer::type_string("The phone number of the property owner."),
    company_name = ellmer::type_string("The name of the company associated with the property owner."),
    company_website = ellmer::type_string("The website of the company associated with the property owner."),
    company_address = ellmer::type_string("The address of the company associated with the property owner."),
    company_domain = ellmer::type_string("The domain of the company associated with the property owner (derived from the company website)."),
    confidence_score = ellmer::type_number("The confidence score of the contact information (0-100).")
  )

}

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string type_number type_array
type_property_analysis <- function() {

  ellmer::type_object(
    .description = "Analysis of a property's investment potential.",
    property_address = ellmer::type_string("The address of the property."),
    property_value = ellmer::type_number("The estimated value of the property."),
    opporitunity_score = ellmer::type_number("Score indicating the investment potential of the property (0-100)."),
    key_factors = ellmer::type_array(
      "Key factors influencing the investment potential of the property.",
      items = ellmer::type_string()
    ),
    recommendation = ellmer::type_string("Recommendation based on the analysis (e.g., 'Buy', 'Hold', 'Sell')."),
    owner_contact = type_owner_contact(),
    analysis_date = ellmer::type_string("The date of the analysis (YYYY-MM-DD format).")
  )

}

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string type_array
type_email_draft <- function() {

  ellmer::type_object(
    .description = "Draft of an email to be sent to a property owner for initial outreach.",
    recipient_name = ellmer::type_string("The name of the email recipient."),
    subject = ellmer::type_string("The subject line of the email."),
    body = ellmer::type_string("The body content of the email."),
    key_points = ellmer::type_array(
      "Key points to be included in the email body.",
      items = ellmer::type_string()
    ),
    sender_name = ellmer::type_string("The name of the sender."),
    sender_email = ellmer::type_string("The email address of the sender."),
    send_date = ellmer::type_string("The date when the email is scheduled to be sent (YYYY-MM-DD format).")
  )

}

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
