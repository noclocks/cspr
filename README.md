
# Charles Street Partners R Package - `cspr`

<!-- badges: start -->
<!-- badges: end -->

## Overview

This package is designed to provide tools and functions for data analysis, visualization, and reporting tailored to the
needs of Charles Street Partners.

It includes structured outputs, prompt templates, and custom tools for processing real-estate property owner company
data by augmenting traditional API driven data retrieval with custom, agentic AI interactions.

## Installation

You can install the development version of cspr from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("noclocks/cspr")
```

## Usage

Below is a comprehensive look at the various tools, functions, and structured outputs available in the package for
processing real-estate property owner company information, retrieving geocoded location data, and analyzing property
investment opportunities.

### Setup

- Load original [HUD Loans Data](data-raw/working/hud_data.csv)
- Select a random property from the dataset
- Load original [HUD Owners Data](data-raw/working/hud_owners.csv)
- Select a random owner from the dataset
- Initialize a new chat/agent

```R
library(cspr)

# load HUD loans data
data("hud_loans")

# select a random property/row
property <- dplyr::slice_sample(hud_loans, n = 1L)

# load owners data
data("hud_owners")

# select a random owner
owner <- dplyr::slice_sample(hud_owners, n = 1L)

# initialize new chat/agent
chat <- initialize_chat()
```

### Property Investment Analysis

Below is an example of how to perform a property investment analysis on the selected property using the
included, custom structured outputs and prompt templates specific to the initial 
property investment analysis task.

> [!NOTE]
> *You can view the property investment opporitunity analysis evaluation prompt template here: [property_investment.prompt.md](inst/prompts/property_investment.prompt.md).

```R
# perform a property investment analysis on the property w/ structured outputs
resp <- chat_extract_property_investment_analysis(chat, property)

# print the structured output to the console
resp
```

results in a structured output with the analysis results and derived score/recommendation:

```R
> resp
$property_name
[1] "Huntington Gardens"

$evaluation_score
[1] 7.5

$recommendation
[1] "Given the competitive interest rate, stable financing, and potential for renovation-led growth in a desirable market, it would be prudent to explore further."

$proceed_with_email
[1] TRUE

$analysis_results
$analysis_results$loan_analysis
[1] "The loan amount is approximately $22.753 million with an interest rate of 3.1% fixed. This rate is quite favorable, given that it's a HUD-backed loan, which typically offers advantageous terms. The low-interest rate signifies cost-effective long-term financing."

$analysis_results$units_analysis
[1] "With 180 units, this property provides a significant potential for rental income. The scale of operations can be favorable for both current income and opportunities for renovation-led growth."

$analysis_results$location_analysis
[1] "The location rating of B in Orange County suggests it is in a moderately attractive area. This county is well-known for its desirability as a place to live, supporting tenant demand. The improvement rating of C indicates potential value-add opportunities if improvements enhance rental income or reduce operating expenses."

$analysis_results$timeline_analysis
[1] "The property was completed in 1980, making it over 40 years old, potentially requiring updates. Loan origination in 2012 and maturity in 2047 indicates a stable horizon, with the possibility of considering midpoint refinancing strategies."


$additional_notes
[1] "While there is uncertainty regarding immediate sale potential, the investment's stable financing and potential upsides warrant further investigation. Checking viability for necessary updates and verifying current market rents may create further clarity."
```

As you can see from the structured output, the analysis results, evaluation score, recommendation, and additional notes are all provided in a structured format for easy interpretation and further action.

You can see the original, traced chat response to see how the agent reasoned while processing the data 
by expanding the details below:

<details><summary>View Traced Chat Response</summary><p>

```markdown
To evaluate the Huntington Gardens property as a potential investment opportunity, let’s analyze the factors one by one:

1. **Loan Amount and Interest Rate Compared to Market Standards:**
   - The loan amount is approximately $22.753 million with an interest rate of 3.1% fixed. This rate is quite favorable, given that it's a HUD-backed loan, which typically offers advantageous terms. The low-interest rate signifies cost-effective long-term financing.

2. **Number of Units:**
   - With 180 units, this property provides a significant potential for rental income. The scale of operations can be favorable for both current income and opportunities for renovation-led growth, making it an attractive acquisition target.

3. **Property's Location and Improvement Ratings:**
   - The location rating of B in Orange County suggests it is in a moderately attractive area. This county is well-known for its desirability as a place to live, which generally supports tenant demand.
   - The improvement rating of C indicates there might be some need for updates, which could offer a potential upside if those improvements can enhance rental income or reduce operating expenses.

4. **Completion Timeline and Market Timing:**
   - The property was completed in 1980, making it over 40 years old. This age may necessitate updating building systems or interiors, but it’s also a common scenario for multifamily investments.
   - Loan origination in 2012 and maturity in 2047 offers a stable horizon, but it’s essential to consider mid-point refinancing or exit strategies due to the property's age.

5. **Property's Sale Price and Loan Origination/Maturity Dates:**
   - With no current sale date or price provided, it’s unclear how the current value compares to historical investment. The long loan duration provides certainty in financing costs.

6. **Owner's Contact Information and Company Details:**
   - Owned by LOMCO, with Stephen Doty as the contact person. The owner is likely seasoned in property management, which can mean the property is well-managed, but could also be an obstacle to negotiation if they are satisfied with current performance.

7. **Additional Notes on Loan Terms or Property Details:**
   - Use of a HUD 223(f) loan provides confidence of lower risk due to federal backing. The fixed interest rate and long amortization period further enhance stability.

**Numerical Score (1-10):** 7.5/10
   - The combination of stable financing, potential for improvement, and a decent location supports this score. The financial leverage with favorable terms is a significant plus.

**Recommendation:**
Given the competitive interest rate, stable financing, and potential for renovation-led growth in a desirable market, it would be prudent to explore further. Tracking down the contact email for Stephen Doty or the company LOMCO would be beneficial to opening a dialogue regarding potential transactions or partnerships.

**Conclusion:**
While there is uncertainty regarding immediate sale potential, the investment's stable financing and potential upsides warrant further investigation. Checking viability for necessary updates and verifying current market rents may create further clarity.

Shall I proceed with retrieving the email addresses for outreach to Stephen Doty or LOMCO?
```

</p></details>

### Google Maps Integrations

You can also use the package to interact with Google Maps API for geocoding addresses and searching for places via
the new Google Maps Places API and the custom tools registered to the chat-bot agent:

Functions:

- `gmaps_geocode_address()`: Geocode an address using the Google Maps Geocoding API
- `gmaps_places_search()`: Search for places using the Google Maps Places API
- `gmaps_find_best_match()`: Find the best match from a list of places based on the input address
- `gmaps_extract_place_info()`: Extract place details from the Google Maps Places API response

Tools:

- `tool_gmaps_geocode_address()`: Geocode an address using the Google Maps Geocoding API
- `tool_gmaps_search_places()`: Search for places using the Google Maps Places API

Structured Output Type Definitions:

- `type_gmaps_geocode_address()`: Structured output type for geocoding an address
- `type_gmaps_search_places()`: Structured output type for searching for places

```R
# geocode the owner's address
resp_geocode <- chat_extract_geocoded_address(chat, owner$owner_full_address)

# collect the place details associated with the owner's company
# via the place details structured output
resp_place_details <- chat_extract_place_details(chat, owner$owner_company, owner$owner_full_address)

# print the structured outputs to the console
resp_geocode
resp_place_details
```

### Hunter.io Email Retrieval

You can also use the package to interact with the Hunter.io API for retrieving email addresses associated with a domain
and person details via the custom tool registered to the chat-bot agent:

Functions:

- `hunter_get_email_address()`
- `hunter_get_company_domain()`
- `hunter_parse_email_response()`

Tools:

- `tool_hunter_get_email_address()`: Retrieve email address for associated owning company domain and contact first/last name.

Structured Output Type Definitions:

- `type_hunter_email_address()`: Structured output type for retrieving email addresses

```R
# get the domain from the google maps places results
domain <- resp_place_details$domain

# get the email address for the domain and initial owner data
resp_email <- chat_extract_hunter_email_address(chat, domain, owner$owner_first_name, owner$owner_last_name)

# print the structured output to the console
resp_email
```

***

*To be continued...*
