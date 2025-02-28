
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
#' - `type_hunter_email_address()`: Defines the structure for email address data.
#' - `type_owner_contact()`: Defines the structure for property owner contact information.
#' - `type_property_analysis()`: Defines the structure for property analysis data.
#' - `type_email_draft()`: Defines the structure for an email draft.
#'
#' @returns
#' Each function returns an [ellmer::type_object()] definition object.
NULL

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string type_number type_array
type_gmaps_geocode_address <- function() {

  ellmer::type_object(
    .description = "Geocoded address data retrieved from Google Maps Geocoding API.",
    formatted_address = ellmer::type_string("The formatted address."),
    latitude = ellmer::type_number("The latitude coordinate."),
    longitude = ellmer::type_number("The longitude coordinate."),
    place_id = ellmer::type_string("The unique place ID."),
    place_types = ellmer::type_array(
      "The types associated with the address.",
      items = ellmer::type_string()
    )
  )

}

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string type_number type_array
type_gmaps_place_details <- function() {

  ellmer::type_object(
    .description = "Details of a place retrieved from Google Maps Places API.",
    name = ellmer::type_string("The name of the company located at the place.", required = FALSE),
    address = ellmer::type_string("The formatted address of the place.", required = FALSE),
    phone = ellmer::type_string("The phone number of the place.", required = FALSE),
    business_status = ellmer::type_string("The business status of the place.", required = FALSE),
    business_type = ellmer::type_string("The primary business type of the place.", required = FALSE),
    latitude = ellmer::type_number("The latitude coordinate of the place.", required = FALSE),
    longitude = ellmer::type_number("The longitude coordinate of the place.", required = FALSE),
    website = ellmer::type_string("The website of the place.", required = FALSE),
    domain = ellmer::type_string("The domain of the website.", required = FALSE),
    google_maps_url = ellmer::type_string("The Google Maps URL of the place.", required = FALSE),
    place_id = ellmer::type_string("The Google Maps unique Place ID.", required = FALSE)
  )

}

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string type_number
type_hunter_email_address <- function() {

  ellmer::type_object(
    .description = "Email address and other information retrieved using the Hunter.io email-finder API.",
    first_name = ellmer::type_string("The first name of the contact."),
    last_name = ellmer::type_string("The last name of the contact."),
    email = ellmer::type_string("The email address of the contact."),
    score = ellmer::type_number("The confidence score of the email address (0-100)."),
    domain = ellmer::type_string("The domain associated with the email address."),
    company = ellmer::type_string("The company associated with the email address."),
    verification_date = ellmer::type_string("The date when the email address was verified (YYYY-MM-DD format).")
  )

}

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
