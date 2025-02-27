

app_server <- function(input, output, session) {

  # Store email draft
  email_draft <- shiny::reactiveVal("")

  # Store AI response
  ai_response <- shiny::reactiveVal("")

  # Generate email draft
  observeEvent(input$generate_email, {
    # Basic template with personalization based on inputs
    draft <- paste0(
      "Subject: Investment Opportunity for ", input$property_name, "\n\n",
      "Dear ", input$owner_name, ",\n\n",
      "I hope this email finds you well. I am writing to express interest in exploring investment opportunities for your property, ",
      input$property_name, " located at ", input$property_address, ".\n\n",
      "We are specifically interested in ", input$investment_type, " opportunities for ",
      input$property_type, " properties like yours with approximately ", input$unit_count,
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

  # Display email template
  output$email_template <- renderUI({
    if (email_draft() == "") {
      return(HTML("<p class='text-muted'>Fill out the form and click 'Generate Email Draft' to create your email.</p>"))
    } else {
      return(HTML(paste0("<pre>", email_draft(), "</pre>")))
    }
  })

  # Clear form action
  observeEvent(input$clear_form, {
    updateTextInput(session, "owner_name", value = "")
    updateTextInput(session, "property_name", value = "")
    updateTextInput(session, "property_address", value = "")
    updateNumericInput(session, "unit_count", value = 50)
    updateSelectInput(session, "property_type", selected = "Multi-Family")
    updateSelectInput(session, "investment_type", selected = "Acquisition")
    updateNumericInput(session, "investment_amount", value = 1000000)
    updateTextAreaInput(session, "additional_notes", value = "")
    updateSelectInput(session, "email_tone", selected = "Professional")
    email_draft("")
  })

  # Copy to clipboard button
  observeEvent(input$copy_email, {
    if (email_draft() != "") {
      runjs("
        navigator.clipboard.writeText($('#email_template pre').text())
          .then(() => {
            alert('Email copied to clipboard!');
          })
          .catch(err => {
            console.error('Error copying text: ', err);
          });
      ")
    }
  })

  # Download email
  output$download_email <- downloadHandler(
    filename = function() {
      paste0("HUD_Outreach_", gsub(" ", "_", input$property_name), ".txt")
    },
    content = function(file) {
      writeLines(email_draft(), file)
    }
  )

  # Handle AI assistant advice
  observeEvent(input$get_advice, {
    # Pre-defined responses about HUD properties and outreach
    responses <- c(
      "When reaching out to HUD property owners, it's helpful to mention your experience with similar properties.",
      "Including specific details about how you can add value to the property can increase response rates.",
      "Consider mentioning any success stories or case studies from similar investments in your email.",
      "For affordable housing properties, emphasize your commitment to maintaining affordability while improving conditions.",
      "Research the owner's other properties before reaching out to personalize your message.",
      "Be clear about your investment criteria and what makes this property a good fit.",
      "If possible, reference any mutual connections or industry relationships.",
      "Follow up after 1-2 weeks if you don't receive a response to your initial email.",
      "Highlight your track record with similar HUD properties in your email.",
      "Mention specific improvements you plan to make to increase the property's value.",
      "Consider offering to meet in person to discuss the opportunity if they're local.",
      "Including details about your financing readiness can make your offer more attractive."
    )

    # Extract keywords from the question to provide more relevant responses
    question <- tolower(input$ai_question)

    if (grepl("tone|formal|friendly|professional", question)) {
      response <- "Email tone is critical. Professional tone works well for initial outreach, while a more friendly tone can be effective for follow-up emails."
    } else if (grepl("follow|up", question)) {
      response <- "For follow-ups, reference your previous email and add a new piece of information or value. Wait 1-2 weeks between follow-ups, and limit to 3 attempts."
    } else if (grepl("subject|line", question)) {
      response <- "Effective subject lines are specific and value-focused. Try 'Investment Opportunity for [Property Name]' or 'Acquisition Proposal: [Property Address]'."
    } else if (grepl("value|proposition", question)) {
      response <- "Clearly state your value proposition - will you improve operations, increase occupancy, renovate units, or maintain affordability while improving conditions?"
    } else if (grepl("contact|information", question)) {
      response <- "Always include multiple contact methods (phone, email, LinkedIn) and indicate your preferred contact method and availability."
    } else {
      # If no specific keywords match, provide a random general tip
      response <- sample(responses, 1)
    }

    ai_response(response)
  })

  # Display AI response
  output$ai_response <- renderText({
    if (ai_response() == "") {
      return("Ask a question about email outreach to get AI assistance.")
    } else {
      return(ai_response())
    }
  })
}
