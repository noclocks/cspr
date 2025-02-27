
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
  ) |>
  dplyr::arrange(
    desc(.data$completion_date),
    .data$impr_rating,
    .data$loc_rating,
    .data$owner_company,
    .data$property_name
  )

hud_owners <- hud_data |>
  dplyr::distinct(
    owner_company,
    owner_first_name,
    owner_last_name,
    owner_address,
    owner_city,
    owner_state,
    owner_zip,
    owner_phone,
    owner_email
  ) |>
  dplyr::mutate(
    owner_id = dplyr::row_number(),
    owner_full_name = paste0(
      .data$owner_first_name, " ",
      .data$owner_last_name
    ) |>
      stringr::str_trim() |>
      stringr::str_replace_all("\\s+", " "),
    owner_company = stringr::str_trim(.data$owner_company) |>
      stringr::str_replace_all(",? The$", "") |>
      stringr::str_replace_all("\\s+", " "),
    owner_address = stringr::str_replace_all(.data$owner_address, "#\\s*\\d+", "") |>
      stringr::str_replace_all("\\s+", " ") |>
      stringr::str_trim(),
    owner_full_address = paste0(
      .data$owner_address, ", ",
      .data$owner_city, ", ",
      .data$owner_state, " ",
      .data$owner_zip
    )
  ) |>
  dplyr::select(
    owner_id,
    owner_company,
    owner_first_name,
    owner_last_name,
    owner_full_name,
    owner_address,
    owner_city,
    owner_state,
    owner_zip,
    owner_full_address,
    owner_phone,
    owner_email
  )

working_dir <- file.path("data-raw/working")
if (!dir.exists(working_dir)) {
  dir.create(working_dir, recursive = TRUE)
}

readr::write_csv(hud_data, file.path(working_dir, "hud_data.csv"))
readr::write_csv(hud_owners, file.path(working_dir, "hud_owners.csv"))

usethis::use_data(hud_data, overwrite = TRUE)
usethis::use_data(hud_owners, overwrite = TRUE)
