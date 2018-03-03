library("dplyr")
library("ggplot2")
library("shiny")
# library("rsconnect")
# library("maps")


data.raw <- read.csv("crypto-markets.csv", stringsAsFactors = FALSE)

typeof(data.raw)

View(data.raw)

# Filter down to top 100
data.df <- as.data.frame(unlist(data.raw))

typeof(data.df)


data.100 <- filter(as.data.frame(data.raw, stringsAsFactors = FALSE), ranknow <= 100)

View(data.100)
