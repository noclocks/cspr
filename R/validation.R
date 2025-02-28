
#  ------------------------------------------------------------------------
#
# Title : Email Validation
#    By : Jimmy Briggs
#  Date : 2025-02-26
#
#  ------------------------------------------------------------------------

#' Email Address and Domain Server Validation
#'
#' @name email_validation
#'
#' @description
#' Validate email addresses and domain servers by checking
#' format and regular expression patterns, `MX` DNS records, and `A` DNS
#' records.
#'
#' Functions:
#'
#' - `validate_email_regex()`: Validates the format of an email address using a regular expression.
#' - `validate_email_mx()`: Validates the email address by checking its MX records and falling back to A records if necessary.
#' - `validate_domain()`: Validates the domain by checking its A and MX records.
#'
#' @param email A character string representing the email address to validate.
#' @param domain A character string representing the domain to validate.
#' @param timeout An integer representing the timeout in seconds for DNS queries.
#'
#' @returns
#' - `validate_email_regex()`: Returns `TRUE` if the email address is valid according to the regex pattern, otherwise `FALSE`.
#' - `validate_email_mx()`: Returns `TRUE` if the email address has valid MX records or A records, otherwise `FALSE`.
#' - `validate_domain()`: Returns `TRUE` if the domain has valid A and MX records, otherwise `FALSE`.
#'
#' @examples
#' email <- "jimmy.briggs@noclocks.dev"
#' validate_email_regex(email)
#' validate_email_mx(email)
#' domain <- sub(".*@", "", email)
#' validate_domain(domain)
NULL

#' @rdname email_validation
#' @export
validate_email_regex <- function(email) {
  pattern <- "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
  grepl(pattern, email)
}

#' @rdname email_validation
#' @export
#' @importFrom cli cli_alert_warning
#' @importFrom cli cli_alert_danger
validate_email_mx <- function(email, timeout = 5) {

  if (!validate_email_regex(email)) {
    return(FALSE)
  }

  domain <- sub(".*@", "", email)

  cmd_mx <- sprintf("dig +time=%d +tries=1 +short mx %s", timeout, shQuote(domain))
  cmd_a <- sprintf("dig +time=%d +tries=1 +short a %s", timeout, shQuote(domain))

  tryCatch({

    res_mx <- system(cmd_mx, intern = TRUE)
    has_mx <- any(grepl("\\bMX\\b", res_mx) & !grepl("\\b0\\b", res_mx))

    if (!has_mx) {

      cli::cli_alert_warning(
        "No valid MX records found for domain: {.field {domain}}. Falling back to A record check."
      )

      res_a <- system(cmd_a, intern = TRUE)
      has_a <- any(grepl("\\bIN\\s+A\\b", res_a))

      if (!has_a) {

        cli::cli_alert_danger(
          "No valid A records found for domain: {.field {domain}}. Email validation failed."
        )

        return(FALSE)
      }
    }

    return(TRUE)

  }, error = function(e) {
    cli::cli_alert_danger(
      "Error checking MX records for domain: {.field {domain}}. Email validation failed."
    )
    return(FALSE)
  })

}

#' @rdname email_validation
#' @export
#' @importFrom cli cli_alert_success
#' @importFrom pingr nsl
#' @importFrom purrr pluck
validate_domain <- function(domain) {

  res_a <- tryCatch({
    pingr::nsl(domain, type = 1L) |> purrr::pluck("answer")
  }, error = function(e) {
    cli::cli_alert_danger(
      "Error checking A records for domain: {.field {domain}}. Domain validation failed."
    )
    return(NULL)
  })

  res_mx <- tryCatch({
    pingr::nsl(domain, type = 15L) |> purrr::pluck("answer")
  }, error = function(e) {
    cli::cli_alert_danger(
      "Error checking MX records for domain: {.field {domain}}. Domain validation failed."
    )
    return(NULL)
  })

  if (is.null(res_a) || is.null(res_mx)) {
    return(FALSE)
  }

  has_a <- nrow(res_a) > 0
  has_mx <- nrow(res_mx) > 0

  if (!has_a) {
    cli::cli_alert_warning(
      "No valid A records found for domain: {.field {domain}}. Domain validation failed."
    )
    return(FALSE)
  }

  if (!has_mx) {
    cli::cli_alert_warning(
      "No valid MX records found for domain: {.field {domain}}. Domain validation failed."
    )
    return(FALSE)
  }

  cli::cli_alert_success(
    "Domain: {.field {domain}} has valid A and MX records."
  )

  return(TRUE)

}

#' Validate Address Format
#'
#' @description
#' Validate the format of a street address by checking if it is in the expected
#' format with the street number and name.
#'
#' @param address A character string with the address string to validate.
#'
#' @returns
#' List with two elements: `valid` (logical) and `address` (character).
#'
#' @export
#'
#' @importFrom stringr str_detect
validate_address <- function(address) {

  has_number <- stringr::str_detect(address, "^\\d+\\s+\\w+")
  has_street <- stringr::str_detect(
    address,
    "\\s(St|Street|Ave|Avenue|Blvd|Boulevard|Dr|Drive|Rd|Road|Ln|Lane|Way|Pkwy|Parkway|Cir|Circle|Ct|Court|Pl|Place|Ter|Terrace)"
  )

  if (!has_number || !has_street) {
    return(
      list(
        valid = FALSE,
        address = address
      )
    )
  }

  list(
    valid = TRUE,
    address = address
  )

}

