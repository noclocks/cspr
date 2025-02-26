
#  ------------------------------------------------------------------------
#
# Title : HUD Data
#    By : Jimmy Briggs
#  Date : 2025-02-25
#
#  ------------------------------------------------------------------------

xl_file <- "data-raw/original/1.17.2025 HUD Loans.xlsx"

col_specs <- list(
  "market" = "text",
  "property_name" = "text",
  "property_address" = "text",
  "property_city" = "text",
  "property_state" = "text",
  "property_zip" = "text",
  "units" = "numeric",
  "impr_rating" = "text",
  "loc_rating" = "text",
  "owner_company" = "text",
  "owner_first_name" = "text",
  "owner_last_name" = "text",
  "owner_address" = "text",
  "owner_city" = "text",
  "owner_state" = "text",
  "owner_zip" = "text",
  "owner_phone" = "text",
  "owner_email" = "text",
  "completion_date" = "text",
  "sale_date" = "text",
  "sale_price" = "numeric",
  "loan_type" = "text",
  "loan_origination_date" = "text",
  "loan_maturity_date" = "text",
  "loan_duration" = "numeric",
  "loan_amount" = "numeric",
  "loan_interest_rate" = "numeric",
  "loan_interest_type" = "text",
  "loan_lender" = "text",
  "loan_comments" = "text",
  "property_location_latitude" = "numeric",
  "property_location_longitude" = "numeric"
)

hud_data <- readxl::read_excel(
  path = xl_file,
  sheet = 1L,
  skip = 1L,
  col_names = names(col_specs),
  col_types = unlist(unname(col_specs)),
  na = c("", "NA")
) |>
  dplyr::mutate(
    dplyr::across(
      tidyselect::all_of(c("completion_date", "sale_date")),
      openxlsx::convertToDate
    ),
    dplyr::across(
      tidyselect::all_of(c("loan_origination_date", "loan_maturity_date")),
      lubridate::mdy
    )
  )

hud_data_working <- hud_data |>
  # derive owner company domains
  dplyr::mutate(
    owner_domain = Vectorize(gmaps_get_company_domain)(
      company_name = .data$owner_company,
      company_address = .data$owner_address,
      city = .data$owner_city,
      state = .data$owner_state,
      zip = .data$owner_zip
    )
  )

usethis::use_data(hud_data, overwrite = TRUE)
