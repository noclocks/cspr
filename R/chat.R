
#  ------------------------------------------------------------------------
#
# Title : Chat
#    By : Jimmy Briggs
#  Date : 2025-02-26
#
#  ------------------------------------------------------------------------

#' Initialize Chat
#'
#' @description
#' Initialize a chat session with the OpenAI API using the `gpt-4o` model and
#' register various tools for geocoding, address cleaning, and domain extraction.
#'
#' @returns
#' An `ellmer::chat` object configured with the specified system prompt and tools.
#'
#' @export
#'
#' @importFrom ellmer chat_openai
#'
#' @seealso [ellmer::chat_openai()] for creating a chat session.
initialize_chat <- function(
    model = "gpt-4o",
    prompt = default_prompt()
) {

  if (!ellmer:::openai_key_exists()) {
    cli::cli_abort(
      "OpenAI API key is not set. Please set it using `ellmer::set_openai_key()`."
    )
  }

  chat <- ellmer::chat_openai(
    system_prompt = prompt,
    model = model
  )

  chat$register_tool(tool_gmaps_places_search())
  chat$register_tool(tool_hunter_get_email_address())

  return(chat)

}

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
