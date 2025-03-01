
#  ------------------------------------------------------------------------
#
# Title : Templates
#    By : Jimmy Briggs
#  Date : 2025-02-28
#
#  ------------------------------------------------------------------------

# render_template <- function(template_path, template_data) {
#
#   if (!file.exists(template_path)) {
#     cli::cli_abort("The provided {.arg template_path}: {.file {template_path}} does not exist.")
#   }
#
#   template <- paste(
#     readLines(
#       template_path,
#       encoding = "UTF-8",
#       warn = FALSE
#     ),
#     collapse = "\n"
#   )
#
#   # determine if the template has any variables
#   # template_variables <- extract_template_variables(template)
#
#   whisker::whisker.render(
#     template,
#     template_data
#   )
#
# }
#
# extract_template_variables <- function(template) {
#
#   stringr::str_extract_all(
#     template,
#     "\\{\\{([a-zA-Z0-9_$.]+)\\}\\}"
#   ) |>
#     purrr::map(stringr::str_replace_all, pattern = "\\{\\{", replacement = "") |>
#     purrr::map(stringr::str_replace_all, pattern = "\\}\\}", replacement = "") |>
#     purrr::map(stringr::str_trim) |>
#     unlist() |>
#     unique()
#
# }
