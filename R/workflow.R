

#' Discover Owner Emails
#'
#' @description
#' This function attempts to discover email addresses for a list of owners by
#' searching for their business information using Google Maps and then using
#' Hunter.io to find email addresses based on the discovered domain and
#' owner first and last name.
#'
#' @details
#' This function processes a data frame of owners, each with their company name,
#' address, phone number, and optionally an existing email address. It first
#' searches for the business information using Google Maps, retrieves the domain,
#' and then attempts to find an email address using Hunter.io. If no email is found,
#' it generates a potential email address based on the owner's name and the discovered domain.
#'
#' @param owners A data frame containing owner information.
#'
#' @returns
#' A data frame with the following columns:
#'
#' - `discovered_domain`: The domain discovered from Google Maps.
#' - `discovered_email`: The email address discovered or generated.
#' - `match_quality`: The quality of the match (if applicable).
#' - `email_score`: The score of the discovered email (if applicable).
#' - `business_phone`: The business phone number.
#' - `business_type`: The type of business.
#' - `business_status`: The status of the business.
#' - `business_website`: The business website.
#' - `business_maps_url`: The Google Maps URL for the business.
#' - `business_latitude`: The latitude of the business location.
#' - `business_longitude`: The longitude of the business location.
#' - `processing_status`: The status of the processing for each record.
#' - `final_email`: The final email address, either existing or discovered/generated.
#'
#' @export
#'
#' @importFrom dplyr mutate case_when
#' @importFrom cli cli_alert_info cli_alert_warning cli_alert_danger
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' hud_owners_data <- data("hud_owners")
#' hud_owners_sample <- dplyr::slice_sample(hud_owners_data, n = 5)
#' discovered_emails <- discover_owner_emails(hud_owners_sample)
#' }
discover_owner_emails <- function(owners) {

  results <- owners |>
    dplyr::mutate(
      discovered_domain = NA_character_,
      discovered_email = NA_character_,
      match_quality = NA_real_,
      email_score = NA_real_,
      business_phone = NA_character_,
      business_type = NA_character_,
      business_status = NA_character_,
      business_website = NA_character_,
      business_maps_url = NA_character_,
      business_latitude = NA_real_,
      business_longitude = NA_real_,
      processing_status = "pending"
    )

  cli::cli_alert_info("Starting email discovery process for {nrow(owners)} owners.")

  total_records <- nrow(results)

  for (i in seq_len(total_records)) {

    pct <- round((i / total_records) * 100, 2)
    record <- results[i, ]

    owner_company <- record$owner_company
    owner_first_name <- record$owner_first_name
    owner_last_name <- record$owner_last_name
    owner_address <- record$owner_full_address
    owner_phone <- record$owner_phone
    owner_email <- record$owner_email

    if (!is.na(owner_email)) {
      cli::cli_alert_info("Skipping record {.field {i}} with existing email: {.field {owner_email}}")
      results$processing_status <- "existing_email"
      next
    }

    cli::cli_alert_info("Processing record {.field {i} of {total_records} ({pct}%)} for company: {.field {owner_company}}")

    tryCatch({
      place_info <- gmaps_places_search(
        company_name = owner_company,
        company_address = owner_address,
        company_phone = owner_phone
      )

      if (is.null(place_info)) {
        cli::cli_alert_warning("No place information found for record {.field {i}}.")
        results$processing_status[i] <- "no_place_info"
        next
      }

      results$discovered_domain[i] <- place_info$domain
      results$business_phone[i] <- place_info$phone
      results$business_type[i] <- place_info$business_primary_type
      results$business_status[i] <- place_info$business_status
      results$business_website[i] <- place_info$website
      results$business_maps_url[i] <- place_info$maps_url
      results$business_latitude[i] <- place_info$latitude
      results$business_longitude[i] <- place_info$longitude

      # if domain found, try and discover email
      if (!is.na(place_info$domain)) {

        email_info <- hunter_get_email_address(
          company_domain = place_info$domain,
          company_name = owner_company,
          first_name = owner_first_name,
          last_name = owner_last_name
        )

        results$discovered_email[i] <- email_info$email
        results$email_score[i] <- email_info$score

        if (!is.na(email_info$email)) {
          results$processing_status[i] <- "email_found"
        } else {
          cli::cli_alert_warning("No email found for record {.field {i}}.")
          generated_email <- glue::glue("{owner_first_name}.{owner_last_name}@{place_info$domain}")
          cli::cli_alert_info("Generated email: {.field {generated_email}}")
          results$discovered_email[i] <- generated_email
          results$processing_status[i] <- "email_generated"
        }

        results$match_quality[i] <- NA_real_  # Placeholder for match quality

      } else {
        cli::cli_alert_warning("No domain found for record {.field {i}}.")
        results$processing_status[i] <- "no_domain"
      }

    }, error = function(e) {
      cli::cli_alert_danger("Error processing record {.field {i}}: {.field {e$message}}")
      results$processing_status[i] <- "error"
    })

    cli::cli_alert_info("Completed record {.field {i}} of {total_records} ({pct}%)")
    Sys.sleep(1)  # Delay to avoid hitting API rate limits
  }

  out <- results |>
    dplyr::mutate(
      final_email = dplyr::case_when(
        !is.na(.data$owner_email) ~ .data$owner_email,
        !is.na(.data$discovered_email) ~ .data$discovered_email,
        TRUE ~ NA_character_
      )
    )

  total <- nrow(out)
  had_email <- sum(!is.na(out$owner_email))
  found_email <- sum(!is.na(out$discovered_email) | !is.na(out$final_email))

  summary <- list(
    total_owners = total,
    had_email = had_email,
    found_email = found_email,
    percent_complete = round((found_email / total) * 100, 2),
    by_status = table(out$processing_status)
  )

  cli::cli_alert_info("Email discovery process completed.")
  print(summary)

  attr(out, "summary") <- summary
  return(out)

}
