# load packages
library("dplyr")
library("ggplot2")
library("shiny")
library("tidyr")

# source scripts
source("scripts/data.R")
source("scripts/ui.R")
source("scripts/server.R")

# call shiny function to render
shinyApp(ui, server)