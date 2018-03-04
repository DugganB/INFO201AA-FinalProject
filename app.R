# load packages
library("dplyr")
library("ggplot2")
library("shiny")
library("tidyr")

# source scripts
source("data.R")
source("ui.R")
source("server.R")

# call shiny function to render
shinyApp(ui, server)