library("dplyr")
library("ggplot2")
library("shiny")


# Grabbing the data from csv and then grabbing the top 100 data.
data.raw <- read.csv("crypto-markets.csv", stringsAsFactors = FALSE)


data.100 <- filter(as.data.frame(data.raw, stringsAsFactors = FALSE), ranknow <= 100)

# grabbing list of all the coins for input
list.coins <- filter(data.100, date == "2018-02-05") %>%
  select(slug)%>%
  as.list()

# function for summary table of 2 specific coins between start and end date.
SumYear <- function(startdate,enddate, coinslugone, coinslugtwo){
  data.year <- filter(data.100, date > startdate & date < enddate, slug == coinslugone | slug == coinslugtwo)
  data.year.sum <- group_by(data.year, slug)%>%
    summarize(spreadmax = max(spread), 
              spreadmin = min(spread),
              spreadmed = median(spread),
              spreadavg = mean(spread),
              spreadIQR = IQR(spread),
              spreadstDev = sd(spread))
  return(as.data.frame(data.year.sum,stringsAsFactor=FALSE))
}

# function for summary table of all coin within date interval
# takes in start and end date and outputs summary data frame for all top 100 coins
TableSum <- function(startdate,enddate){
  data.year <- filter(data.100, date > startdate & date < enddate)
  data.year.sum <- group_by(data.year, slug)%>%
    summarize(spreadmax = max(spread), 
              spreadmin = min(spread),
              spreadmed = median(spread),
              spreadavg = mean(spread),
              spreadIQR = IQR(spread),
              spreadstDev = sd(spread))
  return(as.data.frame(data.year.sum,stringsAsFactor=FALSE))
}

# Grab data necessary and filtered for two chosen coins and start and end date.
# Returns data frame corresponding to the filtered 4 inputs
CoinData <- function(coinslugone, coinslugtwo, startdate, enddate){
  data.coin = filter(data.100, slug == coinslugone | slug == coinslugtwo, 
                     date > startdate & date < enddate)
  return(data.coin)
}


bitcoinscalar <- max(data.100$high)

#function that takes in start, end, and two chosen coin slugs.
# returns a dataframe with the coin high and coin spread scaled to their corresponding peaks
ScaleSpread<- function(startdate, enddate, coinslugone, coinslugtwo){
  coinonefilter <- filter(data.100, slug == coinslugone, date > startdate & date < enddate)
  coinonescalar <- as.double(max(coinonefilter$spread))
  coinoneprice <- as.double(max(coinonefilter$high))
  coinonescaled <- mutate(coinonefilter, scaled.price = high/coinoneprice, scaled.spread = spread/coinonescalar)
  
  cointwofilter <- filter(data.100, slug == coinslugtwo, date > startdate & date < enddate)
  cointwoscalar <- as.double(max(cointwofilter$spread))
  cointwoprice <- as.double(max(cointwofilter$high))
  cointwoscaled <- mutate(cointwofilter, scaled.price  = high/cointwoprice, scaled.spread = spread/cointwoscalar)
  
  joinscaled <- full_join(coinonescaled, cointwoscaled)
  return(joinscaled)
}
