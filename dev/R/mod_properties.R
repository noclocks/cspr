
#  ------------------------------------------------------------------------
#
# Title : Properties Module
#    By : Jimmy Briggs
#  Date : 2025-02-27
#
#  ------------------------------------------------------------------------


mod_properties_ui <- function(id) {

  ns <- shiny::NS(id)

  htmltools::tagList(
    bslib::card(
      bslib::card_header(
        htmltools::tags$span(
          bsicons::bs_icon("buildings"),
          "Property Table"
        )
      ),
      bslib::card_body(
        reactable::reactableOutput(ns("properties_table"))
      )
    ),
    bslib::card(
      bslib::card_header(
        htmltools::tags$span(
          bsicons::bs_icon("map"),
          "Property Map"
        )
      ),
      bslib::card_body(
        leaflet::leafletOutput(ns("properties_map"), height = "400px")
      )
    )
  )

}

mod_properties_server <- function(id, selected_property = NULL) {

  shiny::moduleServer(
    id,
    function(input, output, session) {

      ns <- session$ns
      cli::cat_rule("[Module]: mod_properties_server()")

      if (is.null(selected_property)) {
        selected_property <- shiny::reactiveVal(NULL)
      }

      # Render the properties table
      output$properties_table <- reactable::renderReactable({
        reactable::reactable(
          hud_data,
          columns = list(
            market = reactable::colDef(name = "Market"),
            units = reactable::colDef(name = "Units"),
            rate = reactable::colDef(name = "Interest Rate"),
            loc_rating = reactable::colDef(name = "Location Rating"),
            impr_rating = reactable::colDef(name = "Improvement Rating")
          ),
          selection = "single",
          onClick = "select",
          selected = selected_property()
        )
      })

      # Render the properties map
      output$properties_map <- leaflet::renderLeaflet({
        leaflet::leaflet(hud_data) %>%
          leaflet::addTiles() %>%
          leaflet::addMarkers(~longitude, ~latitude, popup = ~market)
      })

    }
  )

}
