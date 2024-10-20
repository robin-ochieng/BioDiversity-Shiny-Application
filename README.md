# Biodiversity Shiny App

- [About The Project](#about-the-project)
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)
- [Citation](#citation)
- [Acknowledgments](#acknowledgments)

## About the project
This project is developed to display and analyze biodiversity data specifically from Poland. It displays information such as species' kingdoms, families, cities etc. The dataset is extracted from [here](https://www.gbif.org/occurrence/search?dataset_key=8a863029-f435-446a-821e-275f4f641165). 

## Getting started
- Before running the app locally, ensure you have R installed on your machine along with the following R packages:
```r
install.packages(c("shiny", "leaflet", "dplyr", "plotly", "jsonlite", "shinyjs"))
```
- Then you can load the packages:
```r
library(shiny)
library(leaflet)
library(dplyr)
library(plotly)
library(jsonlite)
library(shinyjs)
```
- Module servers and custom functions are located in the **modules** folder whereas the js ones are in **www/js**. 

## Usage
- To run the application locally, navigate to the project directory and run the following in R or RStudio:
```r
shiny::runApp()
```
## License
Distributed under the MIT License. See ```LICENSE``` for more information.

## Citation
 GBIF.org (15 May 2022) GBIF Occurrence Download https://doi.org/10.15468/dl.kyy2gw 