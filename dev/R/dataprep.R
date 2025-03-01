
#  ------------------------------------------------------------------------
#
# Title : Data Preparation & Processing
#    By : Jimmy Briggs
#  Date : 2025-02-27
#
#  ------------------------------------------------------------------------

# data ------------------------------------------------------------------------------------------------------------

encode_df_for_model <- function(df, max_rows = 100, show_end = 10) {
  if (nrow(df) == 0) {
    return(paste(collapse = "\n", capture.output(print(tibble::as.tibble(df)))))
  }
  if (nrow(df) <= max_rows) {
    return(df_to_json(df))
  }
  head_rows <- df[1:max_rows, ]
  tail_rows <- df[(nrow(df) - show_end + 1):nrow(df), ]
  paste(
    collapse = "\n",
    c(
      df_to_json(head_rows),
      sprintf("... %d rows omitted ...", nrow(df) - max_rows),
      df_to_json(tail_rows)
    )
  )
}

df_to_json <- function(data) {
  jsonlite::toJSON(data, dataframe = "rows", na = "string", pretty = TRUE)
}
