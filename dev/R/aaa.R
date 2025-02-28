
.cspr_tools <- list()

.cspr_add_tool <- function(tool_func) {
  stopifnot(is.function(tool_func))
  .cspr_tools[[length(.cspr_tools) + 1]] <<- tool_func
  invisible(tool_func)
}
