
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
#' - `type_property_investment_analysis()`: Defines the structure for property investment analysis data.
#' - `type_hud_data()`: Defines the structure for HUD property loans dataset.
#' - `type_owner_contact()`: Defines the structure for property owner contact information.
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
#' @importFrom ellmer type_object type_string type_number type_boolean
type_property_investment_analysis <- function() {

  ellmer::type_object(
    .description = "Property investment evaluation analysis results",
    property_name = ellmer::type_string(
      "The name of the property that was evaluated.",
      required = TRUE
    ),
    evaluation_score = ellmer::type_number(
      "The evaluation score of the property (0-10).",
      required = TRUE
    ),
    recommendation = ellmer::type_string(
      "The overall recommendation based on the analysis about pursuing the investment opporitunity.",
      required = TRUE
    ),
    proceed_with_email = ellmer::type_boolean(
      "Whether to proceed with finding owner's contact email address for outreach.",
      required = TRUE
    ),
    analysis_results = ellmer::type_object(
      .description = "The detailed analysis results of the property evaluation.",
      .required = TRUE,
      loan_analysis = ellmer::type_string(
        description = "Analysis of loan amount and interest rate",
        required = FALSE
      ),
      units_analysis = ellmer::type_string(
        description = "Analysis of the property's unit count and scale",
        required = FALSE
      ),
      location_analysis = ellmer::type_string(
        description = "Analysis of the property's location and ratings",
        required = FALSE
      ),
      timeline_analysis = ellmer::type_string(
        description = "Analysis of completion timeline and market timing",
        required = FALSE
      )
    ),
    additional_notes = ellmer::type_string(
      description = "Any additional notes or observations",
      required = FALSE
    )
  )

}

#' @rdname types
#' @export
#' @importFrom ellmer type_object type_string type_number type_array
type_hud_data <- function() {
  ellmer::type_array(
    description = "Data structure for HUD property loans dataset.",
    items = ellmer::type_object(
      .description = "A single record representing a property loan in the HUD dataset.",
      market = ellmer::type_string("The market where the property is located."),
      property_name = ellmer::type_string("The name of the property."),
      property_address = ellmer::type_string("The address of the property."),
      property_city = ellmer::type_string("The city where the property is located."),
      property_state = ellmer::type_string("The state where the property is located."),
      property_zip = ellmer::type_string("The ZIP code of the property."),
      units = ellmer::type_number("The number of units in the property."),
      impr_rating = ellmer::type_string("The improvement rating of the property."),
      loc_rating = ellmer::type_string("The location rating of the property."),
      owner_company = ellmer::type_string("The name of the owner's company."),
      owner_first_name = ellmer::type_string("The first name of the property owner."),
      owner_last_name = ellmer::type_string("The last name of the property owner."),
      owner_address = ellmer::type_string("The address of the property owner."),
      owner_city = ellmer::type_string("The city where the property owner is located."),
      owner_state = ellmer::type_string("The state where the property owner is located."),
      owner_zip = ellmer::type_string("The ZIP code of the property owner."),
      owner_phone = ellmer::type_string("The phone number of the property owner."),
      owner_email = ellmer::type_string("The email address of the property owner."),
      completion_date = ellmer::type_string("The completion date of the property."),
      sale_date = ellmer::type_string("The sale date of the property."),
      sale_price = ellmer::type_number("The sale price of the property."),
      loan_type = ellmer::type_string("The type of loan associated with the property."),
      loan_origination_date = ellmer::type_string("The origination date of the loan."),
      loan_maturity_date = ellmer::type_string("The maturity date of the loan."),
      loan_duration = ellmer::type_number("The duration of the loan."),
      loan_amount = ellmer::type_number("The amount of the loan."),
      loan_interest_rate = ellmer::type_number("The interest rate of the loan."),
      loan_interest_type = ellmer::type_string("The type of interest rate for the loan."),
      loan_lender = ellmer::type_string("The lender of the loan."),
      loan_comments = ellmer::type_string("Comments or notes about the loan."),
      property_location_latitude = ellmer::type_number("The latitude coordinate of the property location."),
      property_location_longitude = ellmer::type_number("The longitude coordinate of the property location.")
    )
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
