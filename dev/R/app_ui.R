
app_ui <- function(req) {

  force(req)

  htmltools::tagList(
    # add_external_resources(),
    htmltools::tags$head(
      shinyjs::useShinyjs()
    ),
    bslib::page_sidebar(
      title = "HUD Property Owner Outreach",
      sidebar = bslib::sidebar(
        width = 300,
        title = "Sidebar",
        bslib::accordion(
          id = "sidebar_accordion",
          bslib::accordion_panel(
            title = "Filters",
            value = "filters",
            icon = icon("filter"),

            shiny::selectInput(
              "market",
              "Market",
              choices = c("All Markets", unique(hud_data$market)),
              selected = "All Markets"
            ),
            shiny::sliderInput(
              "units",
              "Number of Units",
              min = 0,
              max = 2000,
              value = c(0, 2000),
              step = 50
            ),
            shiny::sliderInput(
              "rate",
              "Interest Rate",
              min = 1.5,
              max = 4.5,
              value = c(1.5, 4.5),
              step = 0.1
            ),
            shiny::selectInput(
              "location_rating",
              "Location Rating",
              choices = c("All", sort(unique(hud_data$loc_rating))),
              selected = "All"
            ),
            shiny::selectInput(
              "improvement_rating",
              "Improvement Rating",
              choices = c("All", sort(unique(hud_data$impr_rating))),
              selected = "All"
            )
          ),
          bslib::accordion_panel(
            title = "Actions",
            value = "actions",
            icon = icon("cogs"),
            shiny::actionButton("analyze", "Analyze Properties", icon = shiny::icon("chart-bar"), class = "btn-primary"),
            shiny::actionButton("contact", "Draft Contact Email", icon = shiny::icon("envelope"), class = "btn-success"),
            shiny::actionButton("export", "Export Data", icon = shiny::icon("file-export"), class = "btn-info")
          )
        )
      ),

      bslib::layout_column_wrap(
        width = 1/2,
        bslib::card(
          bslib::card_header("Property Details"),
          bslib::card_body(
            reactable::reactableOutput("property_table")
          )
        ),
        bslib::card(
          bslib::card_header("Property Map"),
          bslib::card_body(
            leaflet::leafletOutput("property_map")
          )
        )
      )


        # shiny::textInput("owner_name", "Property Owner Name"),
        # shiny::textInput("property_name", "Property Name"),
        # shiny::textInput("property_address", "Property Address"),
        # shiny::numericInput("unit_count", "Number of Units", value = 50, min = 1),
        # shiny::selectInput("property_type", "Property Type",
        #             choices = c("Multi-Family", "Senior Housing", "Mixed Use", "Affordable Housing")),
        # shiny::selectInput("investment_type", "Investment Type",
        #             choices = c("Acquisition", "Refinancing", "Renovation", "Development")),
        # shiny::numericInput("investment_amount", "Potential Investment Amount ($)",
        #              value = 1000000, min = 100000, step = 100000),
        # shiny::textAreaInput("additional_notes", "Additional Property Notes",
        #               rows = 3, placeholder = "Any specific details about the property..."),
        # htmltools::tags$hr(),
        # shiny::selectInput("email_tone", "Email Tone",
        #             choices = c("Professional", "Friendly", "Direct", "Formal")),
        #
        # shiny::actionButton("generate_email", "Generate Email Draft", class = "btn-primary"),
        # shiny::actionButton("clear_form", "Clear Form", class = "btn-secondary")
      ),
      bslib::layout_columns(
        bslib::card(
          bslib::card_header("Email Draft"),
          bslib::card_body(
            shiny::uiOutput("email_template"),
            htmltools::tags$hr(),
            shiny::actionButton("copy_email", "Copy to Clipboard", icon = icon("copy")),
            shiny::downloadButton("download_email", "Download")
          )
        ),
        bslib::card(
          bslib::card_header("AI Assistant"),
          bslib::card_body(
            shiny::textAreaInput("ai_question", "Ask for help with your outreach email...", rows = 3),
            shiny::actionButton("get_advice", "Get Advice", icon = icon("robot"), class = "btn-info"),
            htmltools::tags$hr(),
            shiny::verbatimTextOutput("ai_response")
          )
        )
      )
    )
  )

}
