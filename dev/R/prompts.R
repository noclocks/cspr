
#  ------------------------------------------------------------------------
#
# Title : Prompts
#    By : Jimmy Briggs
#  Date : 2025-02-25
#
#  ------------------------------------------------------------------------

# prompts -----------------------------------------------------------------

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
