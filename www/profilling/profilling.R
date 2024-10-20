library(profvis)

# Wrap your shiny app call within profvis()
profvis({
  shiny::runApp('C:/Users/Robin Ochieng/OneDrive - Kenbright/Gig/R Shinny/PITCH/Biodiversity-Shiny-Application-Remake')
})




options(shiny.profile = TRUE)
shiny::runApp('C:/Users/Robin Ochieng/OneDrive - Kenbright/Gig/R Shinny/PITCH/Biodiversity-Shiny-Application-Remake')

# After stopping the app, use this to see the log
shiny::showReactLog()


# Enable reactlog before running the app
options(shiny.reactlog = TRUE)
shiny::runApp('C:/Users/Robin Ochieng/OneDrive - Kenbright/Gig/R Shinny/PITCH/Biodiversity-Shiny-Application-Remake')

# After stopping the app, visualize the reactlog
shiny::reactlogShow()
