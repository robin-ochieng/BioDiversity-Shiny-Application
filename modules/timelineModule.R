# modules/timelineModule.R

timelineModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    plotlyOutput(ns("timelinePlot"), height = 500)
  )
}

timelineModuleServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$timelinePlot <- renderPlotly({
      req(data())
      df <- data()

      df <- df %>%
        group_by(observation_date = as.Date(eventDate)) %>%
        arrange(observation_date) %>%
        summarize(count = n(), .groups = 'drop')

      marker_sizes <- sqrt(df$count) * 2  # Scale marker size

      p <- plot_ly(df, x = ~observation_date, y = ~count, type = 'scatter', mode = 'lines+markers',
                  line = list(color = '#636EFA'),
                  marker = list(size = marker_sizes, color = '#EF553B', opacity = 0.7)) %>%
            layout(title = "Observation Timeline",
                   xaxis = list(title = "Date", rangeslider = list(type = "date")),
                   yaxis = list(title = "Number of Observations", tickformat = ".1f", showgrid = FALSE),
                   hovermode = "closest",
                   hoverlabel = list(bgcolor = "white", font = list(family = "Arial, sans-serif", size = 12)),
                   plot_bgcolor = '#E5ECF6',
                   margin = list(l = 60, r = 30, t = 45, b = 50))

      # Check if significant_dates and labels are defined and not empty
      if (exists("significant_dates") && length(significant_dates) > 0 && exists("labels") && length(labels) == length(significant_dates)) {
        p <- p %>% add_annotations(
          x = significant_dates,
          y = rep(max(df$count), length(significant_dates)),
          text = labels,
          showarrow = TRUE,
          arrowhead = 2,
          arrowsize = 1,
          arrowwidth = 2,
          arrowcolor = "#636EFA"
        )
      }

      p  # Return the plot object
    })
  })
}
