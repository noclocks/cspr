

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

# chat ------------------------------------------------------------------------------------------------------------


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
    system_prompt = "You are an assistant that helps analyze HUD property data and find contact information for property owners.",
    model = model
  )

  # chat$register_tool(tool_gmaps_geocode_address)
  # chat$register_tool(tool_clean_address)
  # chat$register_tool(tool_gmaps_get_place_id)
  # chat$register_tool(tool_gmaps_get_place_details)
  # chat$register_tool(tool_get_domain_from_url)

  return(chat)

}
