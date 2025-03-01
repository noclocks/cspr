
#  ------------------------------------------------------------------------
#
# Title : Prompts
#    By : Jimmy Briggs
#  Date : 2025-02-28
#
#  ------------------------------------------------------------------------

#' Default Prompt
#'
#' @description
#' Generate the default system prompt for the chat session.
#'
#' @returns
#' A character string representing the default system prompt.
#'
#' @export
#'
#' @importFrom ellmer interpolate_file
default_prompt <- function() {
  ellmer::interpolate_file(path = pkg_sys("prompts/default.prompt.md"))
}

#' Property Investment Prompt
#'
#' @description
#' User prompt for property investment analysis.
#'
#' @param property_row A data frame representing a property record.
#'
#' @returns
#' A character string representing the prompt for property investment analysis.
#'
#' @export
#'
#' @importFrom ellmer interpolate_file
property_investment_prompt <- function(property_row) {
  ellmer::interpolate_file(
    path = pkg_sys("prompts/property_investment.prompt.md"),
    data = property_row
  )
}
