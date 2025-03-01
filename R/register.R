
#  ------------------------------------------------------------------------
#
# Title : Register Tools
#    By : Jimmy Briggs
#  Date : 2025-02-28
#
#  ------------------------------------------------------------------------

#' Tool Registration
#'
#' @description
#' Register custom, function calling tools to the chat session.
#'
#' - `register_tool()`: Register a single tool.
#' - `register_tools()`: Register multiple tools.
#'
#' @param chat An [ellmer::chat_openai()] object.
#' @param tool An [ellmer::tool()] object.
#' @param tools A list of [ellmer::tool()] objects.
#'
#' @returns
#' While these functions are used for there side-effects (registering tools to the chat session), they do
#' invisibly return the chat object.
#'
#' @export
#'
#' @importFrom cli cli_alert_success
#'
#' @examples
#' \dontrun{
#' chat <- initialize_chat()
#' register_tool(chat, tool_gmaps_places_search())
#' register_tools(chat, list(tool_gmaps_geocode_address(), tool_hunter_get_email_address()))
#' }
register_tool <- function(chat, tool) {
  check_inherits(chat, "Chat")
  check_inherits(tool, "ellmer::ToolDef")
  chat$register_tool(tool)
  cli::cli_alert_success("Successfully registered tool: {.field {tool@name}}")
  return(invisible(chat))
}

#' @rdname register_tool
#' @export
#' @importFrom cli cli_alert_success
register_tools <- function(chat, tools) {
  check_inherits(chat, "Chat")
  for (tool in tools) {
    check_inherits(tool, "ellmer::ToolDef")
    register_tool(chat, tool)
    cli::cli_alert_success("Successfully registered tool: {.field {t@name}}")
  }
  return(invisible(chat))
}
