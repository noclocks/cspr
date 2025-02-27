#' Geocode Address
#'
#' @description
#' Geocode an address using the Google Maps Geocoding API.
#'
#' @param address A character string representing the address to geocode.
#' @param api_key A character string representing the Google Maps API key.
#'   Will default to the result from [get_gmaps_api_key()].
#'
#' @returns
#' A list containing the following elements:
#'
#' - `status`: A character string indicating the status of the API request.
#' - `formatted_address`: A character string representing the formatted address.
#' - `place_id`: A character string representing the place ID.
#' - `place_types`: A character string representing the place types.
#' - `latitude`: A numeric value representing the latitude.
#' - `longitude`: A numeric value representing the longitude.
#'
#' @export
#'
#' @importFrom googleway google_geocode
#' @importFrom purrr pluck
gmaps_geocode_address <- function(address, api_key = get_gmaps_api_key()) {

  cli::cli_alert_info("Geocoding address: {.field {address}}.")

  googleway::set_key(api_key)

  tryCatch({
    resp <- googleway::google_geocode(address = address)
    # gmaps_check_response(resp)
    results <- purrr::pluck(resp, "results")
    formatted_address <- purrr::pluck(results, "formatted_address")
    place_id <- purrr::pluck(results, "place_id")
    place_types <- purrr::pluck(results, "types", 1)
    location <- purrr::pluck(results, "geometry", "location")
    latitude <- purrr::pluck(location, "lat")
    longitude <- purrr::pluck(location, "lng")

    return(
      list(
        status = "OK",
        formatted_address = formatted_address,
        place_id = place_id,
        place_types = place_types,
        latitude = latitude,
        longitude = longitude
      )
    )
  }, error = function(e) {
    return(
      list(
        status = "ERROR",
        error = as.character(e$message),
        formatted_address = NA,
        place_id = NA,
        place_types = NA,
        latitude = NA,
        longitude = NA
      )
    )
  })

}


#' Get Google Maps Place ID
#'
#' @description
#' Get the place ID for a given address using the Google Maps Places API.
#'
#' @param company_name Character string representing the name of the company.
#' @param lat Latitude of the location.
#' @param lon Longitude of the location.
#'
#' @returns
#' The place ID of the company.
#'
#' @export
#'
#' @importFrom googleway google_places
#' @importFrom purrr pluck
gmaps_get_place_id <- function(company_name, lat = NULL, lon = NULL) {

  tryCatch({
    resp_place <- googleway::google_places(
      location = c(lat, lon),
      radius = 100,
      keyword = company_name
    )
    results <- purrr::pluck(resp_place, "results")
    if (length(results) > 0) {
      place_id <- purrr::pluck(results, "place_id")
      return(place_id)
    } else {
      resp_place_search <- googleway::google_places(
        search_string = company_name,
        location = c(lat, lon)
      )
      results_search <- purrr::pluck(resp_place_search, "results")
      if (length(results_search) > 0) {
        place_id <- purrr::pluck(results_search, "place_id")
        return(place_id)
      } else {
        return(list(status = "NOT_FOUND", place_id = NA))
      }
    }
  }, error = function(e) {
    return(list(status = "ERROR", error = as.character(e$message), place_id = NA))
  })

}

#' Get Place Details
#'
#' @description
#' Get the details of a place using the Google Maps Places API.
#'
#' @param place_id A character string representing the place ID.
#' @param api_key A character string representing the Google Maps API key.
#'  Will default to the result from [get_gmaps_api_key()].
#'
#' @returns
#' A list containing the following elements:
#' - `website`: A character string representing the website URL.
#' - `address`: A character string representing the formatted address.
#' - `phone`: A character string representing the formatted phone number.
#' - `name`: A character string representing the name of the place.
#'
#' @export
#'
#' @importFrom googleway google_place_details
#' @importFrom purrr pluck
gmaps_get_place_details <- function(place_id, api_key = get_gmaps_api_key()) {

  googleway::set_key(api_key)

  tryCatch({

    resp <- googleway::google_place_details(place_id)
    results <- purrr::pluck(resp, "result")

    website <- purrr::pluck(results, "website")
    address <- purrr::pluck(results, "formatted_address")
    phone <- purrr::pluck(results, "formatted_phone_number")
    name <- purrr::pluck(results, "name")

    return(
      list(
        website = website,
        address = address,
        phone = phone,
        name = name
      )
    )
  }, error = function(e) {
    return(
      list(
        status = "ERROR",
        error = as.character(e$message),
        website = NA,
        address = NA,
        phone = NA,
        name = NA
      )
    )
  })

}

gmaps_check_response <- function(
    resp,
    arg = rlang::caller_arg(resp),
    call = rlang::caller_env()
) {

  if (!purrr::pluck_exists(resp, "status")) {
    cli::cli_abort(
      "Google Maps API Response, {.arg {arg}}, does not contain the {.field status} field.",
      call = call
    )
  }

  if (!purrr::pluck_exists(resp, "results")) {
    cli::cli_abort(
      "Google Maps API Response, {.arg {arg}}, does not contain the {.field results} field.",
      call = call
    )
  }

  status <- purrr::pluck(resp, "status")
  results <- purrr::pluck(resp, "results")

  if (status != "OK") {
    cli::cli_abort(
      "Google Maps API Response, {.arg {arg}}, returned status: {.field {status}}.",
      call = call
    )
  }

  if (length(results) == 0) {
    cli::cli_alert_danger(
      "Google Maps API Response, {.arg {arg}}, returned {.code NULL} or empty results."
    )
    return(resp)
  }

  return(invisible(resp))

}
