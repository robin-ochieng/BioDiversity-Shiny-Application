
# UI Component
leafletModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    leafletOutput(ns("speciesMap"), height = "500px")
  )
}


# Server Component
# Server Component
leafletModuleServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive expression to filter data based on selected species
    filteredData <- reactive({
      req(data())
      data() %>% 
        select(longitudeDecimal, latitudeDecimal, scientificName, locality, eventDate, individualCount) %>%  # Select only necessary columns
        mutate(locality = gsub("Poland - ", "", locality))
    }) %>% debounce(500)  # Debounce to limit frequency of evaluations
    
    # Base map setup
    poland <- ne_countries(scale = "medium", country = "Poland", returnclass = "sf") %>%
      st_simplify(dTolerance = 0.01)  # Simplify polygons to reduce complexity
    
    baseMap <- reactive({
      leaflet(data = filteredData(), options = leafletOptions(doubleClickZoom = FALSE)) %>%
        addProviderTiles(providers$CartoDB.Voyager) %>%
        addPolygons(data = poland, fillColor = "#f7f4f9", fillOpacity = 0.7, color = "#d95f0e", weight = 2)
    })
    
    # Render the leaflet map
    output$speciesMap <- renderLeaflet({
      leaf <- baseMap()
      
      if (nrow(filteredData()) == nrow(data())) {
        # Show all observations as a heatmap with a blue theme
        leaf %>%
          addCircleMarkers(
            lng = ~longitudeDecimal,
            lat = ~latitudeDecimal,
            popup = ~paste(
              "<strong>Scientific Name:</strong>", scientificName, "<br>",
              "<strong>Locality:</strong>", locality, "<br>",
              "<strong>Date:</strong>", eventDate, "<br>",
              "<strong>Individual Count:</strong>", individualCount
            ),
            radius = ~sqrt(individualCount) * 3,  # Increased size based on sqrt of count
            fillColor = ~ifelse(individualCount > 100, "#FF0000", 
                                ifelse(individualCount > 10, "#FFA500", "#FFFF00")),  # Red, Orange, Yellow for three categories
            color = "#000000",  # Black border color for contrast
            fillOpacity = 0.9,  # Increased opacity
            stroke = TRUE,
            weight = 2  # Increased border weight
          ) %>%
          addLegend(
            position = "bottomleft",
            title = "Count of Individual Observations",
            colors = c("#FF0000", "#FFA500", "#FFFF00"),
            labels = c("High (>100)", "Medium (11-100)", "Low (≤10)"), 
            opacity = 1
          )
      } else {
        # Show specific species observations with improved markers and popups
        leaf %>%
          addCircleMarkers(
            lng = ~longitudeDecimal,
            lat = ~latitudeDecimal,
            popup = ~paste(
              "<strong>Scientific Name:</strong>", scientificName, "<br>",
              "<strong>Locality:</strong>", locality, "<br>",  # Updated to show locality
              "<strong>Date:</strong>", eventDate, "<br>",
              "<strong>Individual Count:</strong>", individualCount
            ),
            radius = ~sqrt(individualCount) * 3,  # Increased size based on sqrt of count
            fillColor = ~ifelse(individualCount > 10, "#FFA500", "#FFFF00"),  # Orange, Yellow for clarity
            color = "#000000",  # Black border color for contrast
            fillOpacity = 0.9,  # Increased opacity
            stroke = TRUE,
            weight = 2  # Increased border weight
          ) %>%
          addLegend(
            position = "bottomleft",
            title = "Count of Individual Observations",
            colors = c("#FFA500", "#FFFF00"),
            labels = c("High (>10)", "Low (≤10)"), 
            opacity = 1
          )
      } %>%
        setView(lng = 19.1451, lat = 51.9194, zoom = 7)  # Slightly adjusted zoom for better focus on Poland
    })
  })
}