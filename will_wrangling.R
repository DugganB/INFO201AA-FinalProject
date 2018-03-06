library("dplyr")
library("ggplot2")
library("shiny")
# library("rsconnect")
# library("maps")


data.raw <- read.csv("crypto-markets.csv", stringsAsFactors = FALSE)

# typeof(data.raw)

# View(data.raw)

# Filter down to top 100
# data.df <- as.data.frame(unlist(data.raw))

# typeof(data.df)


data.100 <- filter(as.data.frame(data.raw, stringsAsFactors = FALSE), ranknow <= 100)

View(data.100)

data.coins <- filter(data.100, date == "2018-02-05") %>%
  select(slug)
# View(data.coins)

# summarizing statistics for a year maybe?
# data.2013 <- filter(data.100, date > "2013-01-01" & date < "2014-01-01")
# View(data.2013)
# data.2013.sum <- group_by(data.2013, slug)%>%
#   summarize(spreadmax = max(spread), 
#             spreadmin = min(spread),
#             spreadmed = median(spread),
#             spreadavg = mean(spread))



# View(data.2013.sum)
# 0 spread from no data available?
# specifically dogecoin, others may be skewed as well. Write about this


SumYear <- function(year){
  nextyear <- year +1
  introdate <- paste0(year,"-01-01")
  enddate <- paste0(nextyear, "-01-01")
  data.year <- filter(data.100, date > introdate & date < enddate)
  data.year.sum <- group_by(data.year, slug)%>%
    summarize(spreadmax = max(spread), 
              spreadmin = min(spread),
              spreadmed = median(spread),
              spreadavg = mean(spread))
  return(data.year.sum)
}

data.2013.sum <- SumYear(2013)
data.2014.sum <- SumYear(2014)
data.2015.sum <- SumYear(2015)
data.2016.sum <- SumYear(2016)
data.2017.sum <- SumYear(2017)
data.2018.sum <- SumYear(2018)

View(data.2013.sum)
View(data.2014.sum)
view(data.2015.sum)
View(data.2016.sum)
View(data.2017.sum)
View(data.2018.sum)

# Potentially do a dataset that compares 2.
# Bitcoin price (or spread) at time compared to coin

# Could try to figure out price compared to spread
# Maybe scale down to be a percentage of the peak for both so they fit on the same chart
# Scale by year peak? Will need a function

# Alternatively, could just compare to averages?

# Could also scale specifically to time


CoinData <- function(coinslugone, coinslugtwo, startdate, enddate){
  data.coin = filter(data.100, slug == coinslugone | slug == coinslugtwo, 
                     date > startdate & date < enddate)
  return(data.coin)
}





test <- CoinData("bitcoin", "ethereum", "2017-01-01", "2018-02-05")
View(test)
?geom_line

# Group by slugs
ggplot(data = test) +
  geom_line(aes(x = date, y = spread, group = slug, color = slug))

ggplot(data = test) +
  geom_line(aes (x = date, y = high, group = slug, color = slug))
  



# ScalePricetoSpread <-

bitcoinscalar <- max(data.100$high)

data.testscalar <- filter(data.100, slug == "bitcoin") %>%
  mutate(high = high / bitcoinscalar)
# Need to figure out how to separate and iterate through all the coins 

# Try finding overall variance of spread between coins?
  # Create a SPREAD statistics table for each coin (max, min, median, mean) for every month?

  # to get a list of differing names filter for most recent update, then grab slug
  

  
# Show how spread varies as price increases or decreases

# Show how spread varies as price of bitcoin increases or decreases

# Ideally, this is plotted.