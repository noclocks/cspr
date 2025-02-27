
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
        title = "Property Details",
        shiny::textInput("owner_name", "Property Owner Name"),
        shiny::textInput("property_name", "Property Name"),
        shiny::textInput("property_address", "Property Address"),
        shiny::numericInput("unit_count", "Number of Units", value = 50, min = 1),
        shiny::selectInput("property_type", "Property Type",
                    choices = c("Multi-Family", "Senior Housing", "Mixed Use", "Affordable Housing")),
        shiny::selectInput("investment_type", "Investment Type",
                    choices = c("Acquisition", "Refinancing", "Renovation", "Development")),
        shiny::numericInput("investment_amount", "Potential Investment Amount ($)",
                     value = 1000000, min = 100000, step = 100000),
        shiny::textAreaInput("additional_notes", "Additional Property Notes",
                      rows = 3, placeholder = "Any specific details about the property..."),
        htmltools::tags$hr(),
        shiny::selectInput("email_tone", "Email Tone",
                    choices = c("Professional", "Friendly", "Direct", "Formal")),

        shiny::actionButton("generate_email", "Generate Email Draft", class = "btn-primary"),
        shiny::actionButton("clear_form", "Clear Form", class = "btn-secondary")
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
