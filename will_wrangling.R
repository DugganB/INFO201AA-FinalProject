library("dplyr")
library("ggplot2")
library("shiny")
# library("rsconnect")
# library("maps")
# install.packages("shinythemes")


data.raw <- read.csv("crypto-markets.csv", stringsAsFactors = FALSE)

# typeof(data.raw)

# View(data.raw)

# Filter down to top 100
# data.df <- as.data.frame(unlist(data.raw))

# typeof(data.df)


data.100 <- filter(as.data.frame(data.raw, stringsAsFactors = FALSE), ranknow <= 100)

 # View(data.100)

list.coins <- filter(data.100, date == "2018-02-05") %>%
  select(slug)%>%
  as.list()
# View(list.coins)
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


SumYear <- function(startdate,enddate, coinslugone, coinslugtwo){
  # nextyear <- year +1
  # introdate <- paste0(year,"-01-01")
  # enddate <- paste0(nextyear, "-01-01")
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

TableSum <- function(startdate,enddate){
  # nextyear <- year +1
  # introdate <- paste0(year,"-01-01")
  # enddate <- paste0(nextyear, "-01-01")
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
data.sumtable.test <- SumYear("2014-01-01", "2018-02-05", "bitcoin", "ethereum")
typeof(data.sumtable.test)

# View(data.sumtable.test)


# View(data.2013.sum)
# 
# data.2014.sum <- SumYear(2014)
# data.2015.sum <- SumYear(2015)
# data.2016.sum <- SumYear(2016)
# data.2017.sum <- SumYear(2017)
# data.2018.sum <- SumYear(2018)

# View(data.2013.sum)
# View(data.2014.sum)
# view(data.2015.sum)
# View(data.2016.sum)
# View(data.2017.sum)
# View(data.2018.sum)

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
# View(test)
# ?geom_line

# Group by slugs
ggplot(data = test) +
  geom_line(aes(x = date, y = spread, group = slug, color = slug))

ggplot(data = test) +
  geom_line(aes (x = date, y = high, group = slug, color = slug))
  

# too many lines, too expensive
# ggplot(data = data.100) +
#   geom_line(aes(x = date, y = spread, group = slug, color = slug))



bitcoinscalar <- max(data.100$high)

testcoin <- "ethereum"

# testcoinscalar <- as.(unlist(testcoinscalar.wtf)
# typeof(testcoinscalar)
# View(testcoinscalar)


data.testscalar <- filter(data.100, slug == "bitcoin" | slug == testcoin) %>%
  mutate(scaled.price = high / bitcoinscalar, scaled.spread = spread / max(spread))



# Create a variable that uses scaled high for bitcoin and scaled spread for other coin
# Put it into 1 column so we can use that as a reference point

# View(data.testscalar)
# Comparison of spread of bitcoin and testcoin (ethereum) to max spread
ggplot(data = data.testscalar) +
  geom_line (aes(x = date, y= scaled.spread, group = slug, color = slug))

# comparison of spread of bitcoin and testcoin (ethereum) to a scaled max price (max price of bitcoin)
ggplot(data = data.testscalar) +
  geom_line (aes(x = scaled.price, y = scaled.spread, group = slug, color = slug))


# limit by max spread of smaller coin?

testcoinfilter <- filter(data.100, slug == testcoin)
testcoinscalar <- as.double(max(testcoinfilter$spread))
testcoinprice <- as.double(max(testcoinfilter$high))
# dividing by smaller coin in spread or price is still same result, just on differing scale. Would have to filter for results
# within a certain amount.

data.testmaxspread <- filter(data.100, slug == "bitcoin" | slug == testcoin, spread <= testcoinscalar) %>%
  mutate(scaled.price = high / bitcoinscalar, scaled.spread = spread / testcoinscalar)

ggplot(data = data.testmaxspread) +
  geom_line (aes(x = scaled.price, y= scaled.spread, group = slug, color = slug))


# limit by max price of smaller coin?
data.testmaxprice <- filter(data.100, slug == "bitcoin" | slug == testcoin, high <= testcoinprice) %>%
  mutate(scaled.price = high / bitcoinscalar, scaled.spread = spread / testcoinscalar)

ggplot(data = data.testmaxprice) +
  geom_line (aes(x = scaled.price, y= scaled.spread, group = slug, color = slug))

# limit by max price and max spread of smaller coin
data.testspreadprice <- filter(data.100, slug == "bitcoin" | slug == testcoin, high <= testcoinprice, spread <= testcoinscalar) %>%
  mutate(scaled.price = high / testcoinprice, scaled.spread = spread / testcoinscalar)
ggplot(data = data.testspreadprice) +
  geom_line (aes(x = scaled.price, y= scaled.spread, group = slug, color = slug))


# Attempting to convert process into method
# ScaleSpread<- function(coin){
#   coinfilter <- filter(data.100, slug == coin)
#   coinscalar <- as.double(max(coinfilter$spread))
#   coinprice <- as.double(max(coinfilter$high))
#   
#   data.scalecoin <- filter(data.100, slug == "bitcoin" | slug == coin, high <= coinprice )%>%
#     mutate(scaled.price = high/coinprice, scaled.spread = spread/coinscalar)
#   return(data.scalecoin)
# }

# # View(data.100)
# data.testmethod <- ScaleSpread("ethereum")
# ggplot(data = data.testmethod)+
#   geom_line (aes(x = scaled.price, y= scaled.spread, group = slug, color = slug))

# Fix issue of scale being too small on other coins besides ethereum to be on the same graph as bitcoin 

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

# startdate = "2017-01-01"
# enddate = "2018-02-05"
# coinslugone = "bitcoin"
# coinslugtwo = "ethereum"
# coinonefilter <- filter(data.100, slug == coinslugone, date > startdate & date < enddate)
# coinonescalar <- as.double(max(coinonefilter$spread))
# coinoneprice <- as.double(max(coinonefilter$high))
# coinonescaled <- mutate(coinonefilter, scaled.price = high/coinoneprice, scaled.spread = spread/coinonescalar)
# 
# cointwofilter <- filter(data.100, slug == coinslugtwo, date > startdate & date < enddate)
# cointwoscalar <- as.double(max(cointwofilter$spread))
# cointwoprice <- as.double(max(cointwofilter$high))
# cointwoscaled <- mutate(cointwofilter, scaled.price  = high/cointwoprice, scaled.spread = spread/cointwoscalar)
# 
# joinscaled <- full_join(coinonescaled, cointwoscaled)
# 
# 
# ggplot(data = joinscaled) +
#   geom_line (aes(x = scaled.price, y= scaled.spread, group = slug, color = slug))
# View(joinscaled)
# View(cointwoscaled)
# View(coinonescaled)
# 










# Could do a facet wrap of slug, and graph by date and spread
# 
# ggplot(data = data.100) +
#   geom_line(aes(x = date, y = spread, group = slug))+
#   facet_wrap(~slug)



# ggplot(data = data.testscalar) +
#   geom_line (aes(y = scaled.price, x = scaled.spread, group = slug, color = slug))


# 
# spreadscalar <- filter(data.100, slug == testcoin) %>%
#   mutate(scaled.)

# Need to figure out how to separate and iterate through all the coins 

# Try finding overall variance of spread between coins?
  # Create a SPREAD statistics table for each coin (max, min, median, mean) for every month?

  # to get a list of differing names filter for most recent update, then grab slug
  

  
# Show how spread varies as price increases or decreases

# Show how spread varies as price of bitcoin increases or decreases

# Ideally, this is plotted.