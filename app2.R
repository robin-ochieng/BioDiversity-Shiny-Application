# Sourcing the necessary libraries
library(shiny)
library(leaflet)
library(dplyr)
library(plotly)
library(shinyjs)
library(bs4Dash)
library(data.table)
library(bslib)
library(stringr)
library(shinycssloaders)
library(shinyjs)
library(rnaturalearthdata)
library(rnaturalearth)
library(sf)
library(leaflet.extras)
library(htmlwidgets)


# Sourcing utility script
source("modules/utils.R", local = TRUE)

# Sourcing the modules
source("modules/leafletModule.R", local = TRUE)
source("modules/timelineModule.R", local = TRUE)
source("modules/speciesSelectionModule.R", local = TRUE)
source("modules/valueBoxModule.R", local = TRUE)

# Define a custom theme using bslib
my_theme <- bs_theme(
  bg = "#202123", 
  fg = "#E1E1E1", 
  primary = "#EA80FC", 
  info = "#17a2b8",
  secondary = "#00BFA5",
  base_font = font_google("Mulish"),
  heading_font = font_google("Mulish"),
  code_font = font_google("Mulish"),
  navbar_bg = "#333333",  # Darker background for the navbar for contrast
  navbar_fg = "#ffffff"  # White text color for readability
)


# UI
ui <- bs4DashPage(
  dark = NULL,
  help = NULL,
  fullscreen = FALSE,
  scrollToTop = TRUE,
  freshTheme = my_theme,
  sidebar = bs4DashSidebar(
    disable = TRUE
  ),
  header = bs4DashNavbar(
    status = "white",
    skin = "dark",
    title = dashboardBrand(
      title =  HTML("<div style='display: flex; align-items: center;'>
                      <strong style='font-weight: bold;'>Biodiversity Dashboard</strong>
                      </div>"),
      color = "white",
      image = NULL  
    ),
    .rightUi = div(
      tags$img(src = "svg/logo.svg", class = "right-logo", height = "50px"),
      style = "display: flex; align-items: center; justify-content: flex-end; width: 100%;"
    ),
    navbarMenu(
      tabName = "dashboard",
      menuItem("", tabName = "dashboard")
    )
  ),
  body = bs4DashBody(
    useShinyjs(), 
    tags$head(
      tags$script(src = "www/js/script.js"),
      includeCSS("www/css/custom_styles.css")
    ),
    div(id = "splashScreen", img(src = "svg/logo.svg", height = "30%")),
    tabItems(
      tabItem(
        tabName = "dashboard",
        valueBoxModuleUI("valueBoxModule"),
        fluidRow(
          hr(),
          column(
            width = 4,
            div(id = "species_selector_container", class = "species-selector-container",
                speciesSelectionUI("species_selector")
            ),
            hr()
          ),
          hr()
        ),
        fluidRow(
          bs4Card(
            width = 6,
            solidHeader = TRUE,
            status = "white",
            title = "Map of Species Observations by Count in Poland",
            withSpinner(leafletModuleUI("main_map"), type = 5, proxy.height = "400px"),
            collapsible = TRUE,
            maximizable = TRUE
          ),
          bs4Card(
            width = 6,
            solidHeader = TRUE,
            status = "white",
            title = "Timeline of Selected Species observations",
            withSpinner(timelineModuleUI("speciesTimeline"), type = 5, proxy.height = "400px"),
            collapsible = TRUE
          )
        )
      )
    )
  ),
  footer = bs4DashFooter(
    div(style = "background-color: #ffffff; color: black; text-align: center; padding: 8px;", 
        "© 2024 Robin")
  ) 
)

# Server
server <- function(input, output, session) {
  
  # Using shinyjs to hide the splash screen after 2 seconds
  runjs('setTimeout(function() { $("#splashScreen").addClass("fadeOut"); }, 2000);')
  
  #loading the data
  raw_data <- reactive({fread("data/poland.csv")})
  
  # Get the filtered data from the module
  selected_species_data <- speciesSelectionServer("species_selector", raw_data)
  
  # Map Module
  leafletModuleServer("main_map", selected_species_data)
  
  # Timeline Module
  timelineModuleServer("speciesTimeline", selected_species_data)
  
  # Value Box Module
  valueBoxModuleServer("valueBoxModule", selected_species_data)
  
}

# Run the Shiny App
shinyApp(ui = ui, server = server)
