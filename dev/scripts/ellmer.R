library(ellmer)

chat <- chat_openai(
  system_prompt = "You are a helpful assistant that aids with processing real-estate property owner company information and retrieving geocoded location data.",
  model = "gpt-4o"
)

gmaps_geocode_address_tool <- ellmer::tool(
  .fun = gmaps_geocode_address,
  .description = "Function to geocode a given address using Google Maps API.",
  .name = "gmaps_geocode_address",
  address = ellmer::type_string(
    "The address to be geocoded.",
    required = TRUE
  ),
  api_key = ellmer::type_string(
    "The API key to authenticate requests. Defaults to the value from `get_gmaps_api_key()`.",
    required = FALSE
  )
)

chat$register_tool(gmaps_geocode_address_tool)

gmaps_geocode_address_type <- ellmer::type_object(
  status = ellmer::type_string("The status of the API request."),
  formatted_address = ellmer::type_string("The formatted address."),
  place_id = ellmer::type_string("The place ID."),
  place_types = ellmer::type_string("The place types."),
  latitude = ellmer::type_number("The latitude."),
  longitude = ellmer::type_number("The longitude.")
)

chat$extract_data(
  "Get the geocoded location data for the following company and address:
  Company: {company_name},
  Address: {company_address}",
  type = gmaps_geocode_address_type
)
