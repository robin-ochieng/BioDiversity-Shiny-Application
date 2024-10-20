# modules/valueBoxModule.R
valueBoxModuleUI <- function(id) {
  ns <- NS(id)
  fluidRow(
    valueBoxOutput(ns("totalIndBox"), width = 4),
    valueBoxOutput(ns("uniqueSpeciesBox"), width = 4),
    valueBoxOutput(ns("dateRangeBox"), width = 4)
  )
}


# modules/valueBoxModule.R
valueBoxModuleServer <- function(id, selected_species_data) {
  moduleServer(id, function(input, output, session) {
    output$totalIndBox <- renderValueBox({
      total_ind <- sum(as.numeric(selected_species_data()$individualCount), na.rm = TRUE)
      valueBox(
        format(total_ind, big.mark = ","), "Total Individuals", icon = icon("users"), color = "white"
      )
    })
    
    output$uniqueSpeciesBox <- renderValueBox({
      unique_species <- length(unique(selected_species_data()$scientificName))
      valueBox(
        unique_species, "Unique Species Count", icon = icon("leaf"), color = "white"
      )
    })
    
    output$dateRangeBox <- renderValueBox({
      date_range <- range(as.Date(selected_species_data()$eventDate))
      valueBox(
        paste(format(date_range[1], "%d %B, %Y"), "to", format(date_range[2], "%d %B, %Y")),
        "Observation Date Range", icon = icon("calendar"), color = "white"
      )
    })
  })
}
