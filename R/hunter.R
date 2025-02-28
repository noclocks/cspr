
#  ------------------------------------------------------------------------
#
# Title : Hunter.io API Functions
#    By : Jimmy Briggs
#  Date : 2025-02-27
#
#  ------------------------------------------------------------------------

#' Get Email Address via Hunter.io
#'
#' @description
#' This function retrieves an email address based on the provided company domain, company name,
#' and person's first and last name using the Hunter.io API.
#'
#' @param company_domain Character string representing the company domain.
#' @param company_name Character string representing the company name.
#' @param first_name Character string representing the person's first name.
#' @param last_name Character string representing the person's last name.
#' @param api_key Hunter.io API key. If not provided, uses [get_hunterio_api_key()] to retrieve it.
#'
#' @returns
#' A list containing the following elements:
#'
#' - `first_name`: The first name of the person.
#' - `last_name`: The last name of the person.
#' - `email`: The retrieved email address.
#' - `score`: The score of the email address.
#' - `domain`: The company domain.
#' - `company`: The company name.
#' - `phone_number`: The phone number associated with the email address.
#' - `verification_date`: The date of email verification.
#'
#' @export
#'
#' @importFrom httr2 request req_url_query req_perform resp_check_status resp_body_json
#' @importFrom purrr pluck pluck_exists
#' @importFrom cli cli_alert_info cli_alert_danger cli_alert_success cli_alert_warning
hunter_get_email_address <- function(
    company_domain,
    company_name,
    first_name,
    last_name,
    api_key = get_hunterio_api_key()
) {

  base_url <- "https://api.hunter.io/v2/email-finder"

  full_name <- clean_first_last_name(first_name, last_name)
  company_name_clean <- clean_company_name(company_name)

  req <- httr2::request(base_url) |>
    httr2::req_url_query(
      domain = company_domain,
      company = company_name,
      full_name = full_name,
      api_key = api_key
    )

  tryCatch({
    resp <- httr2::req_perform(req)
    httr2::resp_check_status(resp)
    resp_json <- httr2::resp_body_json(resp)
    hunter_parse_email_response(resp_json)
  }, error = function(e) {
    cli::cli_alert_danger("Error performing request: {e$message}")
    list(
      first_name = NA_character_,
      last_name = NA_character_,
      email = NA_character_,
      score = NA_real_,
      domain = company_domain,
      company = company_name_clean,
      phone_number = NA_character_,
      verification_date = NA_character_
    )
  })
}

#' Parse Hunter.io Email Response
#'
#' @description
#' This function parses the JSON response from the Hunter.io API for email discovery and verification.
#'
#' @param resp_json The JSON response from the Hunter.io API.
#'
#' @returns
#' A list containing the following elements:
#'
#' - `first_name`: The first name of the person.
#' - `last_name`: The last name of the person.
#' - `email`: The retrieved email address.
#' - `score`: The score of the email address.
#' - `domain`: The company domain.
#' - `company`: The company name.
#' - `phone_number`: The phone number associated with the email address.
#' - `verification_date`: The date of email verification.
#'
#' @export
#'
#' @importFrom purrr pluck
hunter_parse_email_response <- function(resp_json) {

  data <- purrr::pluck(resp_json, "data")

  if (!is.null(data)) {
    return(
      list(
        first_name = purrr::pluck(data, "first_name", .default = NA_character_),
        last_name = purrr::pluck(data, "last_name", .default = NA_character_),
        email = purrr::pluck(data, "email", .default = NA_character_),
        score = purrr::pluck(data, "score", .default = NA_real_),
        domain = purrr::pluck(data, "domain", .default = NA_character_),
        company = purrr::pluck(data, "company", .default = NA_character_),
        phone_number = purrr::pluck(data, "phone_number", .default = NA_character_),
        verification_date = purrr::pluck(data, "verification", "date", .default = NA_character_)
      )
    )
  } else {
    cli::cli_alert_warning("No data found in the response.")
    return(
      list(
        first_name = NA_character_,
        last_name = NA_character_,
        email = NA_character_,
        score = NA_real_,
        domain = NA_character_,
        company = NA_character_,
        phone_number = NA_character_,
        verification_date = NA_character_
      )
    )
  }

}

#' Get Company Domain via Hunter.io
#'
#' @description
#' This function retrieves the domain of a company based on its name using the Hunter.io API.
#'
#' @param company_name Character string representing the name of the company.
#' @param api_key Hunter.io API key. If not provided, uses [get_hunterio_api_key()] to retrieve it.
#'
#' @returns
#' A character string representing the domain of the company. If no domain is found, returns `NA`.
#'
#' @export
#'
#' @importFrom httr2 request req_url_query req_perform resp_check_status resp_body_json
#' @importFrom purrr pluck pluck_exists
#' @importFrom cli cli_alert_info cli_alert_danger cli_alert_success
hunter_get_company_domain <- function(
  company_name,
  api_key = get_hunterio_api_key()
) {

  base_url <- "https://api.hunter.io/v2/domain-search"

  req <- httr2::request(base_url) |>
    httr2::req_url_query(
      company = company_name,
      api_key = api_key
    )

  domain <- tryCatch({
    resp <- httr2::req_perform(req)
    httr2::resp_check_status(resp)
    resp_json <- httr2::resp_body_json(resp)
    if (purrr::pluck_exists(resp_json, "data", "domain")) {
      cli::cli_alert_success("Domain found: {.field {purrr::pluck(resp_json, 'data', 'domain')}}")
      purrr::pluck(resp_json, "data", "domain")
    } else {
      cli::cli_alert_danger("No domain found for the company: {company_name}")
      NA_character_
    }
  }, error = function(e) {
    cli::cli_alert_danger("Error performing request: {e$message}")
    NA_character_
  })

  if (is.na(domain)) {
    cli::cli_alert_danger("Failed to retrieve domain for the company: {company_name}")
  }

  return(domain)

}

