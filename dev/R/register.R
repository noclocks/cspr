
#  ------------------------------------------------------------------------
#
# Title : Register Custom Tools
#    By : Jimmy Briggs
#  Date : 2025-02-28
#
#  ------------------------------------------------------------------------

#' Register Tools
#'
#' @description
#' Register custom tools for geocoding, address cleaning, and domain extraction with the `cspr` chat agent.
#'
#' @param chat An `ellmer::chat` object.
#'
#' @returns
#' Invisibly returns the modified `ellmer::chat` object.
#'
#' @export
#'
#' @seealso [tools()]
register_tools <- function(chat) {

  check_inherits(chat, "Chat")

  for (tool in .cspr_tools) {
    chat$register_tool(tool())
  }

  invisible(chat)

}

.list_tools <- function() {
  x <- vapply(.cspr_tools, FUN.VALUE = character(1), function(tool) {
    sprintf("- **%s**: %s", tool()@name, tool()@description)
  })
  paste(x, collapse = "\n")
}
