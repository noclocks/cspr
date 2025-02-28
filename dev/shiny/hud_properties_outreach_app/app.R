library(shiny)
library(shinyjs)
library(bslib)
library(dplyr)
library(reactable)
library(leaflet)
library(shinychat)
library(ellmer)
library(tibble)

source("R/data.R")
source("R/ai.R")

# UI definition
ui <- htmltools::tagList(
  htmltools::tags$head(
    tags$script(HTML("
    $(document).on('reactable:selectionChange', function(e) {
      Shiny.setInputValue('table_selection_changed', true, {priority: 'event'});
    });
  ")),
    useShinyjs()
  ),
  bslib::page_sidebar(
    title = "HUD Property Owner Outreach",
    theme = bs_theme(version = 5),
    sidebar = bslib::sidebar(
      width = 400,
      style = "height: 100%",
      title = "AI Assistant",
      shinychat::chat_ui(
        "chat",
        height = "100%",
        placeholder = "Ask a question about HUD properties or outreach strategies...",
        fill = TRUE
      )
    ),
    navset_card_underline(
      id = "main_tabs",
      nav_panel(
        title = "Properties",
        value = "properties",
        icon = bsicons::bs_icon("buildings"),
        layout_sidebar(
          sidebar = sidebar(
            title = "Selected Property",
            textOutput("selected_property_name"),
            hr(),
            actionButton("go_to_email", "Create Email", class = "btn-primary w-100"),
            accordion(
              accordion_panel(
                title = "Property Details",
                value = "property_details",
                icon = icon("info-circle"),
                shiny::htmlOutput("property_details")
              )
            )
          ),
          card(
            card_header("Property Table"),
            card_body(
              reactableOutput("property_table")
            )
          ),
          card(
            card_header("Property Map"),
            card_body(
              leafletOutput("property_map", height = "400px")
            )
          )
        )
      ),
      nav_panel(
        title = "Email Outreach",
        value = "outreach",
        icon = bsicons::bs_icon("envelope"),
        layout_sidebar(
          sidebar = sidebar(
            width = 300,
            title = "Selected Property",
            textOutput("email_property_name"),
            hr(),
            accordion(
              accordion_panel(
                title = "Email Configuration",
                value = "email_config",
                icon = icon("envelope"),
                selectInput("investment_type", "Investment Type",
                            choices = c("Acquisition", "Refinancing", "Renovation", "Development")),
                numericInput("investment_amount", "Potential Investment Amount ($)",
                             value = 1000000, min = 100000, step = 100000),
                textAreaInput("additional_notes", "Additional Property Notes",
                              rows = 3, placeholder = "Any specific details about the property..."),
                selectInput("email_tone", "Email Tone",
                            choices = c("Professional", "Friendly", "Direct", "Formal"))
              )
            )
          ),
          layout_columns(
            col_widths = c(12),
            card(
              card_header("Email Draft"),
              card_body(
                actionButton("generate_email", "Generate Email Draft", class = "btn-primary w-100 mb-2"),
                actionButton("clear_form", "Clear Form", class = "btn-secondary w-100"),
                hr(),
                div(
                  id = "email_draft",
                  class = "mt-3 d-none",
                  textInput("email_subject", "Subject:", width = "100%"),
                  textAreaInput("email_body", "Body:", rows = 10, width = "100%", placeholder = "Draft your email here...")
                ),
                layout_columns(
                  col_widths = c(4, 4, 4),
                  actionButton("copy_email", "Copy to Clipboard", icon = icon("copy")),
                  downloadButton("download_email", "Download"),
                  actionButton("send_email", "Send Email", class = "btn-success w-100")
                )
              )
            )
          )
        )
      )
    )
  ),
  shiny::useBusyIndicators()
)

# Server logic
server <- function(input, output, session) {

  chat <- initialize_chat()
  chat_history <- reactiveVal(NULL)

  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    shinychat::chat_append("chat", stream)
  })

  # Store selected property data
  selected_property <- reactiveVal(NULL)

  # Store email draft
  email_draft <- reactiveVal("")

  # Store AI response
  ai_response <- reactiveVal("")

  # Render property table
  output$property_table <- renderReactable({
    reactable(
      hud_data %>%
        select(property_name, market, property_city, property_state, units, loan_amount, owner_company),
      columns = list(
        .selection = colDef(
          width = 80,
          sticky = "left",
          style = list(cursor = "pointer"),
          headerStyle = list(cursor = "pointer")
        ),
        property_name = colDef(name = "Property Name"),
        market = colDef(name = "Market"),
        property_city = colDef(name = "City"),
        property_state = colDef(name = "State"),
        units = colDef(name = "Units", align = "right"),
        loan_amount = colDef(name = "Loan Amount (M)",
                             format = colFormat(prefix = "$", separators = TRUE, digits = 2),
                             align = "right"),
        owner_company = colDef(name = "Owner")
      ),
      selection = "single",
      highlight = TRUE,
      striped = TRUE,
      theme = reactableTheme(
        rowSelectedStyle = list(backgroundColor = "#eee", boxShadow = "inset 2px 0 0 0 #ffa62d")
      ),
      resizable = TRUE,
      wrap = FALSE,
      bordered = TRUE,
      onClick = "select",
      defaultSelected = 1
    )
  })

  selected <- reactive({
    getReactableState("property_table", "selected")
  })

  # Handle table selection changes using getReactableState
  observeEvent(selected(), {
    selected <- selected()
    if (length(selected) > 0) {
      # In reactable, the index is 0-based, but we need 1-based for R
      row_index <- selected + 1  # Convert to 1-based indexing
      selected_property(hud_data[row_index, ])

      # Center map on selected property
      property <- hud_data[row_index, ]
      leafletProxy("property_map") %>%
        setView(lng = property$property_location_longitude,
                lat = property$property_location_latitude,
                zoom = 14)
    }
  })

  # Render property map
  output$property_map <- renderLeaflet({
    leaflet(hud_data) %>%
      addTiles() %>%
      addMarkers(
        ~property_location_longitude,
        ~property_location_latitude,
        popup = ~paste0("<b>", property_name, "</b><br>",
                        property_address, "<br>",
                        property_city, ", ", property_state, " ", property_zip, "<br>",
                        "Units: ", units, "<br>",
                        "Loan Amount: $", loan_amount, "M<br>",
                        "Owner: ", owner_company),
        layerId = ~seq_along(property_name)
      ) %>%
      setView(lng = -95.7129, lat = 37.0902, zoom = 4)
  })

  # Handle map marker clicks
  observeEvent(input$property_map_marker_click, {
    click <- input$property_map_marker_click
    row_index <- as.numeric(click$id)
    updateReactable("property_table", selected = row_index - 1)  # reactable uses 0-based indexing
    selected_property(hud_data[row_index, ])
  })

  # Display selected property name (in both tabs)
  output$selected_property_name <- renderText({
    if (is.null(selected_property())) {
      return("No property selected")
    } else {
      prop <- selected_property()
      return(paste0(prop$property_name, " (", prop$property_city, ", ", prop$property_state, ")"))
    }
  })

  output$email_property_name <- renderText({
    if (is.null(selected_property())) {
      return("No property selected")
    } else {
      prop <- selected_property()
      return(paste0(prop$property_name, " (", prop$property_city, ", ", prop$property_state, ")"))
    }
  })

  # Display detailed property information
  output$property_details <- renderUI({
    if (is.null(selected_property())) {
      return(HTML("<p class='text-muted'>Select a property to view details.</p>"))
    } else {
      prop <- selected_property()

      HTML(paste0(
        "<strong>Address:</strong> ", prop$property_address, "<br>",
        "<strong>City:</strong> ", prop$property_city, ", ", prop$property_state, " ", prop$property_zip, "<br>",
        "<strong>Units:</strong> ", prop$units, "<br>",
        "<strong>Owner:</strong> ", prop$owner_company, "<br>",
        "<strong>Contact:</strong> ", prop$owner_first_name, " ", prop$owner_last_name, "<br>",
        "<strong>Loan Amount:</strong> $", formatC(prop$loan_amount, format="f", digits=2), "M<br>",
        "<strong>Interest Rate:</strong> ", prop$loan_interest_rate, "%"
      ))
    }
  })

  observeEvent(input$go_to_email, {
    nav_select("main_tabs", "outreach")
  })

  # Generate email draft
  observeEvent(input$generate_email, {
    if (is.null(selected_property())) {
      showNotification("Please select a property first", type = "warning")
      return()
    }

    prop <- selected_property()
    owner_name <- paste(prop$owner_first_name, prop$owner_last_name)

    # Start drafting the email
    draft <- paste0(
      "Dear ", owner_name, ",\n\n",
      "I hope this email finds you well. I am writing to express interest in exploring investment opportunities for your property, ",
      prop$property_name, " located at ", prop$property_address, " in ", prop$property_city, ", ", prop$property_state, ".\n\n",
      "We are specifically interested in ", input$investment_type, " opportunities for properties like yours with approximately ", prop$units,
      " units. Our investment group is prepared to commit up to $", formatC(input$investment_amount, format="f", big.mark=",", digits=0),
      " for the right opportunity.\n\n"
    )

    # Add additional notes if provided
    if (input$additional_notes != "") {
      draft <- paste0(draft, "Additional notes regarding the property: ", input$additional_notes, "\n\n")
    }

    # Closing based on email tone
    closings <- list(
      "Professional" = "I would welcome the opportunity to discuss this further at your convenience. Please let me know if you're interested in exploring this potential partnership.",
      "Friendly" = "I'd love to jump on a call to chat about how we might work together. Feel free to reach out anytime!",
      "Direct" = "Please review this opportunity and let me know if you're interested in proceeding. I'm available to discuss terms immediately.",
      "Formal" = "I kindly request the opportunity to present our investment proposal in more detail. Please advise regarding your availability for a formal discussion."
    )

    draft <- paste0(draft, closings[[input$email_tone]], "\n\n",
                    "Thank you for your consideration.\n\n",
                    "Best regards,\n",
                    "[Your Name]\n",
                    "[Your Company]\n",
                    "[Your Contact Information]")

    email_draft(draft)
  })

  observeEvent(email_draft(), {
    if (email_draft() == "") {
      txt <- HTML("<p class='text-muted'>Fill out the form and click 'Generate Email Draft' to create your email.</p>")
    } else {
      formatted_email <- gsub("\n", "<br>", email_draft())
      txt <- HTML(paste0("<div class='bg-light p-3 rounded'>", formatted_email, "</div>"))
    }

    updateTextInput(session, "email_subject", value = paste("Investment Opportunity for", selected_property()$property_name))
    updateTextAreaInput(session, "email_body", value = txt)
  })

  # Clear form action
  observeEvent(input$clear_form, {
    updateSelectInput(session, "investment_type", selected = "Acquisition")
    updateNumericInput(session, "investment_amount", value = 1000000)
    updateTextAreaInput(session, "additional_notes", value = "")
    updateSelectInput(session, "email_tone", selected = "Professional")
    email_draft("")
    selected_property(NULL)
  })

  # Copy to clipboard button
  observeEvent(input$copy_email, {
    if (email_draft() != "") {
      # Using shinyjs to copy to clipboard
      js_code <- paste0("navigator.clipboard.writeText(`", gsub("`", "\\\\`", email_draft()), "`)\n                        .then(() => { Shiny.notification('Email copied to clipboard!', {type: 'message', closeButton: true}); })\n                        .catch(err => { console.error('Error copying text: ', err); });")
      runjs(js_code)
    } else {
      showNotification("No email to copy", type = "warning")
    }
  })

  # Download email
  output$download_email <- downloadHandler(
    filename = function() {
      if (is.null(selected_property())) {
        return("HUD_Outreach_Email.txt")
      } else {
        prop <- selected_property()
        return(paste0("HUD_Outreach_", gsub("[^a-zA-Z0-9]", "_", prop$property_name), ".txt"))
      }
    },
    content = function(file) {
      writeLines(email_draft(), file)
    }
  )

  # Handle AI assistant advice
  observeEvent(input$get_advice, {
    if (input$ai_question == "") {
      showNotification("Please enter a question for the AI assistant", type = "warning")
      return()
    }

    # Pre-defined responses about HUD properties and outreach
    responses <- c(
      "When reaching out to HUD property owners, highlighting your experience with similar properties can increase your credibility.",
      "Consider mentioning specific improvements you plan to make that align with HUD priorities like affordability and community impact.",
      "Including case studies of similar successful investments can make your email more compelling.",
      "For affordable housing properties, emphasize both your financial capabilities and your commitment to maintaining affordability.",
      "Research the owner's portfolio before reaching out to personalize your approach and demonstrate your interest.",
      "Be clear about your specific investment criteria and what specifically makes this property a good fit.",
      "If possible, reference mutual connections or industry relationships to build trust.",
      "When following up, add new information or value rather than just checking in.",
      "Your track record with similar HUD properties should be prominently featured in your initial outreach.",
      "For construction loans, discuss your experience with similar development projects and timelines.",
      "Consider offering a site visit or in-person meeting to demonstrate your serious interest.",
      "Providing proof of financing readiness can significantly strengthen your position."
    )

    # Extract keywords from the question to provide more relevant responses
    question <- tolower(input$ai_question)

    if (grepl("tone|formal|friendly|professional", question)) {
      response <- "Email tone is critical for outreach. Professional tone works well for initial outreach to established companies, while a more friendly tone can be effective for smaller property owners. Direct tone is best when you've already established some relationship."
    } else if (grepl("follow|up", question)) {
      response <- "For follow-ups, reference your previous email and add a new piece of value or information. Wait 7-10 days between follow-ups, and limit to 2-3 attempts. Consider changing the channel (email to phone) if you don't get a response."
    } else if (grepl("subject|line", question)) {
      response <- "Effective subject lines for property outreach are specific and value-focused. Try 'Investment Opportunity for [Property Name]', 'Partnership Proposal: [Property Address]', or 'Acquisition Interest: [Property Type] in [Location]'."
    } else if (grepl("value|proposition", question)) {
      response <- "Your value proposition should address the owner's likely concerns: Will you improve operations? Increase NOI? Renovate while minimizing disruption? For HUD properties, also emphasize your commitment to program compliance and community benefit."
    } else if (grepl("contact|information", question)) {
      response <- "Always include multiple contact methods (phone, email, LinkedIn) and indicate your preferred method and availability. For key prospects, consider creating a personalized calendar link for them to schedule time with you."
    } else {
      # If no specific keywords match, provide a random general tip
      response <- sample(responses, 1)
    }

    ai_response(response)
  })

  # Display AI response
  output$ai_response <- renderText({
    if (ai_response() == "") {
      return("Ask a question about property outreach to get AI assistance.")
    } else {
      return(ai_response())
    }
  })

}

shinyApp(ui = ui, server = server)
