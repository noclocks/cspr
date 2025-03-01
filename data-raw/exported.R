
#  ------------------------------------------------------------------------
#
# Title : Exported Data Preparations
#    By : Jimmy Briggs
#  Date : 2025-03-01
#
#  ------------------------------------------------------------------------

# HUD Data --------------------------------------------------------------------------------------------------------

source("data-raw/scripts/hud_data.R")

usethis::use_data(hud_data, overwrite = TRUE)
usethis::use_data(hud_owners, overwrite = TRUE)
