
#  ------------------------------------------------------------------------
#
# Title : Prompts
#    By : Jimmy Briggs
#  Date : 2025-02-28
#
#  ------------------------------------------------------------------------

#' Prompts
#'
#' @name prompts
#'
#' @description
#' A collection of functions for generating prompts for the chat agent.
#'
#' Functions:
#'
#' - `prompt_default_sys()`: Generate the default system prompt for the chat session.
#' - `prompt_property_investment_user()`: User prompt for property investment analysis.
#'
#' @param property_row A data frame representing a property record. Must be a single row.
#'
#' @returns
#' - `prompt_default_sys()`: A character string representing the default system prompt.
#' - `prompt_property_investment_user()`: A character string representing the prompt for property investment analysis.
#'
#' @seealso [ellmer::interpolate_file()]
NULL

#' @rdname prompts
#' @export
#' @importFrom ellmer interpolate_file
prompt_default_sys <- function() {
  ellmer::interpolate_file(path = pkg_sys("prompts/default.system.prompt.md"))
}

#' @rdname prompts
#' @export
#' @importFrom ellmer interpolate_file
prompt_property_investment_user <- function(property_row) {
  ellmer::interpolate_file(
    path = pkg_sys("prompts/property_investment.prompt.md"),
    data = property_row
  )
}

