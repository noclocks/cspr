
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
#' - `tool_gmaps_geocode_address()`: Geocode an address using the Google Maps Geocoding API.
#' - `tool_hunter_get_email_address()`: Retrieve an email address based on the provided company domain, company name,
#'   and person's first and last name using the Hunter.io API.
#'
#' @returns
#' Each function returns an [ellmer::tool()] definition object.
NULL


# google maps places search ---------------------------------------------------------------------------------------

#' @rdname tools
#' @export
#' @importFrom ellmer tool
#' @importFrom purrr partial
#' @importFrom memoise memoise
tool_gmaps_places_search <- function() {

  func <- purrr::partial(gmaps_places_search, api_key = get_gmaps_api_key())
  mem_func <- memoise::memoise(func)

  rlang::inject(
    ellmer::tool(
      .name = "gmaps_places_search",
      .description = paste0(
        "Search for places using Google Maps Places API to find various information about the company located at the place.\n",
        "This tool returns the name, address, phone number, business status, business primary type, business types, \n",
        "latitude, longitude, google maps URL, google maps Place Id, website, and domain of the company located at the place."
      ),
      .fun = mem_func,
      !!!.gmaps_places_search_types
    )
  )

}


# google maps geocode address -------------------------------------------------------------------------------------

#' @rdname tools
#' @export
#' @importFrom ellmer tool
#' @importFrom purrr partial
#' @importFrom memoise memoise
tool_gmaps_geocode_address <- function() {

  func <- purrr::partial(gmaps_geocode_address, api_key = get_gmaps_api_key())
  mem_func <- memoise::memoise(func)

  rlang::inject(
    ellmer::tool(
      .name = "gmaps_geocode_address",
      .description = paste0(
        "Geocode an address using the Google Maps Geocoding API.\n",
        "This tool returns the formatted address, latitude, longitude, place ID, and place types."
      ),
      .fun = mem_func,
      !!!.gmaps_geocode_address_types
    )
  )

}


# hunter.io email finder ------------------------------------------------------------------------------------------

#' @rdname tools
#' @export
#' @importFrom ellmer tool
#' @importFrom purrr partial
#' @importFrom memoise memoise
tool_hunter_get_email_address <- function() {

  func <- purrr::partial(hunter_get_email_address, api_key = get_hunterio_api_key())
  mem_func <- memoise::memoise(func)

  rlang::inject(
    ellmer::tool(
      .name = "hunter_get_email_address",
      .description = paste0(
        "Retrieve an email address based on the provided company domain, company name, and person's first and last name\n",
        " using the Hunter.io API. This tool returns the first name, last name, email address, score, domain, company,\n",
        " phone number, and verification date."
      ),
      .fun = mem_func,
      !!!.hunter_get_email_address_types
    )
  )

}

.gmaps_places_search_types <- list(
  company_name = ellmer::type_string("The name of the company to search for.", required = TRUE),
  company_address = ellmer::type_string("The address of the company to search for.", required = TRUE),
  company_phone = ellmer::type_string("The phone number of the company to search for.", required = FALSE)
)

.gmaps_geocode_address_types <- list(
  address = ellmer::type_string("The address to geocode.", required = TRUE)
)

.hunter_get_email_address_types <- list(
  company_domain = ellmer::type_string("The company domain to search for.", required = TRUE),
  company_name = ellmer::type_string("The company name to search for.", required = TRUE),
  first_name = ellmer::type_string("The person's first name to search for.", required = TRUE),
  last_name = ellmer::type_string("The person's last name to search for.", required = TRUE)
)

