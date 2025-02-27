
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
#' - `tool_clean_address()`: Cleans and formats an address.
#' - `tool_gmaps_geocode_address()`: Geocodes a given address using Google Maps API.
#' - `tool_gmaps_get_place_id()`: Gets the place ID for a given company name.
#' - `tool_gmaps_get_place_details()`: Fetches detailed information about a place.
#' - `tool_get_domain_from_url()`: Extracts the domain from a URL.
#'
#' @returns
#' Each function returns an [ellmer::tool()] definition object.
NULL

#' @rdname tools
#' @export
#' @importFrom ellmer tool type_string type_number type_object
tool_clean_address <- function() {
  ellmer::tool(
    .fun = clean_address,
    .description = paste0(
      "Cleanse and format an address in a standardized manner by removing unnecessary elements and characters and ",
      "combining the address, city,  state, and zip code components into a single string."
    ),
    .name = "clean_address",
    address = ellmer::type_string(
      "The address to be cleaned.",
      required = TRUE
    ),
    city = ellmer::type_string(
      "The city name. Default is `NULL`.",
      required = FALSE
    ),
    state = ellmer::type_string(
      "The state abbreviation. Default is `NULL`.",
      required = FALSE
    ),
    zip = ellmer::type_string(
      "The zip code. Default is `NULL`.",
      required = FALSE
    )
  )
}

#' @rdname tools
#' @export
#' @importFrom ellmer tool type_string type_number type_object
tool_gmaps_geocode_address <- function() {
  ellmer::tool(
    .fun = gmaps_geocode_address,
    .description = "Function to geocode a given address using Google Maps API.",
    .name = "gmaps_geocode_address",
    address = ellmer::type_string(
      "The address to be geocoded.",
      required = TRUE
    ),
    api_key = ellmer::type_string(
      "The API key to authenticate requests. Defaults to the value from `get_gmaps_api_key()`.",
      required = FALSE
    )
  )
}

#' @rdname tools
#' @export
#' @importFrom ellmer tool type_string type_number type_object
tool_gmaps_get_place_id <- function() {
  ellmer::tool(
    .fun = gmaps_get_place_id,
    .description = "Function to get the place ID for a given comapny name using Google Maps API.",
    .name = "gmaps_get_place_id",
    company_name = ellmer::type_string(
      "The company name to get the place ID for.",
      required = TRUE
    ),
    lat = ellmer::type_number(
      "The latitude of the location. Default is `NULL`.",
      required = FALSE
    ),
    lon = ellmer::type_number(
      "The longitude of the location. Default is `NULL`.",
      required = FALSE
    )
  )
}

#' @rdname tools
#' @export
#' @importFrom ellmer tool type_string type_number type_object
tool_gmaps_get_place_details <- function() {
  ellmer::tool(
    .fun = gmaps_get_place_details,
    .description = "Fetches detailed information about a place identified by its place_id using the Google Maps API.",
    place_id = ellmer::type_string(
      "The unique identifier of the place for which details are requested."
    ),
    api_key = ellmer::type_string(
      "Your Google Maps API key. If not provided, it defaults to the value returned by `get_gmaps_api_key()`.",
      required = FALSE
    )
  )
}

#' @rdname tools
#' @export
#' @importFrom ellmer tool type_string type_number type_object
tool_get_domain_from_url <- function() {
  ellmer::tool(
    .fun = get_domain_from_url,
    .description = "Extract the domain from a URL string by removing the protocol and any sub-domains.",
    url = ellmer::type_string(
      "A character string representing the URL to extract the domain from."
    )
  )
}
