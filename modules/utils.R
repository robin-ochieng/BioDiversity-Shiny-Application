# Function to calculate total number of individuals
total_individuals <- function(data) {
  sum(as.numeric(data$individualCount), na.rm = TRUE)
}

# Function to calculate unique species count
unique_species_count <- function(data) {
  length(unique(data$scientificName))
}

# Function to get observation date range
observation_date_range <- function(data) {
  range(as.Date(data$eventDate))
}




