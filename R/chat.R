
#  ------------------------------------------------------------------------
#
# Title : Chat
#    By : Jimmy Briggs
#  Date : 2025-02-26
#
#  ------------------------------------------------------------------------

#' Initialize Chat
#'
#' @description
#' Initialize a chat session with the OpenAI API using the `gpt-4o` model (by default) and
#' register the necessary custom function calling tools for performing property investent
#' analysis, Google Maps API functions, and Hunter.io API functions.
#'
#' @returns
#' An `ellmer::chat` object configured with the specified system prompt and tools.
#'
#' @export
#'
#' @importFrom ellmer chat_openai
#'
#' @seealso [ellmer::chat_openai()] for creating a chat session.
initialize_chat <- function(
    model = "gpt-4o",
    system_prompt = default_prompt(),
    api_key = get_openai_api_key(),
    echo = c("none", "text", "all")
) {

  echo <- rlang::arg_match(echo)

  chat <- ellmer::chat_openai(
    system_prompt = system_prompt,
    model = model,
    echo = echo,
    api_key = api_key
  )

  chat$register_tool(tool_gmaps_places_search())
  chat$register_tool(tool_gmaps_geocode_address())
  chat$register_tool(tool_hunter_get_email_address())

  return(chat)

}

#' Extract Owner Company Details
#'
#' @description
#' Extract the owner company details from the chat response.
#'
#' @param chat An `ellmer::chat` object.
#' @param owner_company_name A character string representing the name of the owner's company.
#' @param owner_company_address A character string representing the address of the owner's company.
#' @param owner_first_name A character string representing the first name of the owner.
#' @param owner_last_name A character string representing the last name of the owner.
#' @param owner_phone A character string representing the phone number of the owner.
#'
#' @returns
#' A list containing the owner company details information.
#'
#' @export
chat_extract_owner_company_details <- function(
    chat,
    owner_company_name,
    owner_company_address,
    owner_first_name,
    owner_last_name,
    owner_phone = NULL
) {

  check_inherits(chat, "Chat")

  tryCatch({

    # get place details
    resp_place_details <- chat_extract_place_details(
      chat,
      company_name = owner_company_name,
      company_address = owner_company_address
    )

    # get email address for the owner
    resp_email <- chat_extract_hunter_email_address(
      chat,
      company_domain = resp_place_details$domain,
      company_name = owner_company_name,
      first_name = owner_first_name,
      last_name = owner_last_name
    )

    list(
      initial_owner_data = list(
        owner_company_name = owner_company_name,
        owner_company_address = owner_company_address,
        owner_first_name = owner_first_name,
        owner_last_name = owner_last_name,
        owner_phone = owner_phone
      ),
      gmaps_place_details = resp_place_details,
      hunter_email = resp_email
    )

  }, error = function(e) {
    cli::cli_alert_danger("Error processing owner details: {.field {e$message}}")
    list(
      initial_owner_data = list(
        owner_company_name = owner_company_name,
        owner_company_address = owner_company_address,
        owner_first_name = owner_first_name,
        owner_last_name = owner_last_name,
        owner_phone = owner_phone
      ),
      gmaps_place_details = NULL,
      hunter_email = NULL
    )
  })

}

#' Extract Geocoded Address
#'
#' @description
#' Extract the geocoded address from the chat response.
#'
#' @param chat An `ellmer::chat` object.
#' @param address A character string representing the address to geocode.
#'
#' @returns
#' A list containing the geocoded address information.
#'
#' @export
chat_extract_geocoded_address <- function(chat, address) {
  stopifnot(inherits(chat, "Chat"))
  qry <- paste0("Geocode the address: ", address)
  resp <- chat$chat(qry)
  chat$extract_data(resp, type = type_gmaps_geocode_address())
}

#' Extract Place Details
#'
#' @description
#' Extract the place details from the chat response.
#'
#' @param chat An `ellmer::chat` object.
#' @param company_name A character string representing the name of the company.
#' @param company_address A character string representing the address of the company.
#' @param company_phone A character string representing the phone number of the company.
#'
#' @returns
#' A list containing the place details information.
#'
#' @export
chat_extract_place_details <- function(chat, company_name, company_address, company_phone = NULL) {
  stopifnot(inherits(chat, "Chat"))
  qry <- paste0("Get the place details for ", company_name, " at ", company_address)
  if (!is.null(company_phone)) qry <- paste0(qry, " with phone number ", company_phone)
  resp <- chat$chat(qry)
  chat$extract_data(resp, type = type_gmaps_place_details())
}

#' Extract Hunter Email Address
#'
#' @description
#' Extract the email address from the chat response using the Hunter.io API.
#'
#' @param chat An `ellmer::chat` object.
#' @param company_domain A character string representing the company domain.
#' @param company_name A character string representing the company name.
#' @param first_name A character string representing the first name of the person.
#' @param last_name A character string representing the last name of the person.
#'
#' @returns
#' A list containing the email address information.
#'
#' @export
chat_extract_hunter_email_address <- function(chat, company_domain, company_name, first_name, last_name) {
  stopifnot(inherits(chat, "Chat"))
  qry <- paste0("Get the email address for ", first_name, " ", last_name, " at ", company_name, " (", company_domain, ")")
  resp <- chat$chat(qry)
  chat$extract_data(resp, type = type_hunter_email_address())
}
