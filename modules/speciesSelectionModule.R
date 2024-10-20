speciesSelectionUI <- function(id) {
  ns <- NS(id)
  selectizeInput(
    ns("species_name"),
    label = "Search Species by Name (Vernacular or Scientific)",
    choices = NULL,
    multiple = FALSE,
    options = list(placeholder = 'Select species', server = TRUE)
  )
}

speciesSelectionServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Combine vernacularName and scientificName into one searchable column
    combined_names <- reactive({
      req(data())
      data_df <- data()
      data_df %>%
        mutate(combinedName = paste(vernacularName, "(", scientificName, ")", sep = ""))
    })

    # Update selectizeInput with the combined names
    observe({
      updateSelectizeInput(session, "species_name", choices = unique(combined_names()$combinedName), server = TRUE)
    })

    # Filter data based on the selected species or return all data if none is selected
    selected_data <- reactive({
      if (is.null(input$species_name) || input$species_name == "") {
        combined_names()  # Return all data if no species is selected
      } else {

        # Extracting the vernacularName and scientificName from the selected input
        selected_vernacular <- str_extract(input$species_name, "^[^\\(]+")
        selected_scientific <- str_extract(input$species_name, "(?<=\\().*(?=\\))")
        
        # Filter the data using both extracted names
        combined_names() %>%
            filter(vernacularName == selected_vernacular & scientificName == selected_scientific)
        }
    })

    return(selected_data)
  })
}


