# read in data and select columns
data <- read.csv("crypto-markets100.csv", stringsAsFactors = FALSE)

data.filter.trends <- select(data, symbol, name, date, open, close)


data.100 <- data

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


# grabbing list of all the coins for input
list.coins <- filter(data.100, date == "2018-02-05") %>%
    select(slug)%>%
    as.list()

list.crash <- c("November 2013", "Mt. Gox", "2017 Chinese FUD", "End of 2017")

coinTimeFrame <- function(startDate, endDate, coinSlug){
    data.timeFrame <- filter(data.100, date > startDate & date < endDate, slug == coinSlug)
    return(data.timeFrame)
}


# Generates the summary table for the crash given a start and end date
coinDropSummary <- function(startDate, endDate){
    data.timeFrame <- filter(data.100, date > startDate & date < endDate)
    data.timeFrame.sum <- group_by(data.timeFrame, slug) %>%
        summarise(high = max(high),
                  low = min(low),
                  'Max market cap' = max(market),
                  'Low Market Cap' = min(market),
                  'Total Drop' = paste0(round((1-(min(market)/max(market)))*100, 2), '%'))
    return(data.timeFrame.sum)
}

# Returns the correct start date for a crash
crashstartdate <- function(crash){
    if(crash == 'November 2013'){
        return(as.Date('2013-11-18'))
    } else if(crash == 'Mt. Gox'){
        return(as.Date('2013-11-08'))
    } else if(crash == '2017 Chinese FUD'){
        return(as.Date('2017-05-08'))
    } else if(crash == 'End of 2017'){
        return(as.Date('2017-12-08'))
    }
}

# Returns the correct end date for a crash
crashenddate <- function(crash){
    if(crash == 'November 2013'){
        return(as.Date('2013-12-28'))
    } else if(crash == 'Mt. Gox'){
        return(as.Date('2014-08-08'))
    } else if(crash == '2017 Chinese FUD'){
        return(as.Date('2017-08-01'))
    } else if(crash == 'End of 2017'){
        return(as.Date('2018-02-08'))
    }
    
}

# This will return the correct info that should be displayed below the graph
getCrashInfo <- function(crash, coin) {
    filteredcoin <- coinTimeFrame(crashstartdate(crash), crashenddate(crash), coin)
    if(crash == 'November 2013'){
        toreturn <- paste0("This crash can be seen to have been caused by the fact that Chinese investors were said to not be as ",
                           "interested in bitcoin as previously thought. The graph is showing a period of about 2 months. You can see ",
                           "that the one coin that we have data for (bitcoin) saw a sharp decline and a very rapid riseback.", 
                           "The high for ", as.character(crash), " was ", max(filteredcoin$max), " and a min of ", 
                           min(filteredcoin$min), ". Which, equates to a drop of ", 
                           round((1-(min(filteredcoin$market)/max(filteredcoin$market)))*100, 2), '%')
        return(toreturn)
    } else if(crash == 'Mt. Gox'){
        toreturn <- paste0("During this crash Mt. Gox, which was the biggest exchange for Bitcoin at the time, declared that they were ", 
                           "hacked. In February 2014 Mt. Gox declared that they were hacked and that 650,000 Bitcoin were missing ", 
                           "and that the users of Mt. Gox would not get their Bitcoin back. Prior to the crash Mt. Gox handled", 
                           "around 70% of all Bitcoin exchange volume worldwide. The high for ", as.character(crash), 
                           " was ", max(filteredcoin$max), " and a min of ", min(filteredcoin$min), ". Which, equates to a drop of ", 
                           round((1-(min(filteredcoin$market)/max(filteredcoin$market)))*100, 2), "%.")
        return(toreturn)
    } else if(crash == '2017 Chinese FUD') {
        toreturn <- paste0("During this downtrend in crypto, rumors were circulating that China would ban cryptocurrency. They ended up ",
                           "regulating ICOs and the SEC also jumped on the wagen and started making sure people did not get scammed. ",
                           "This crash had so little news that went along with it, most of it was all rumors driving the price down.",
                           " The high for ", as.character(crash), 
                           " was ", max(filteredcoin$max), " and a min of ", min(filteredcoin$min), ". Which, equates to a drop of ", 
                           round((1-(min(filteredcoin$market)/max(filteredcoin$market)))*100, 2), "%.")
        return(toreturn)
    } else if(crash == 'End of 2017'){
        toreturn <- paste0("This is crypto's most recent crash(or correction). Not much is known about what has caused this latest ", 
                           "crash. New information just came out where it has been revealed Mt. Gox has been selling bitcoin off all ", 
                           "through this latest crash. People now believe that this is the central cause of the crash and the dip down ", 
                           "to around $6000 a bitcoin. The high for ", as.character(crash), 
                           " was ", max(filteredcoin$max), " and a min of ", min(filteredcoin$min), ". Which, equates to a drop of ", 
                           round((1-(min(filteredcoin$market)/max(filteredcoin$market)))*100, 2), "%.")
        return(toreturn)
    }
}

# Filtered data for Market Cap
market.data.filter <- data %>% select(symbol, name, date, open, close, market, ranknow) %>%
  filter(market != 0) %>% mutate(market = as.numeric(market)) %>%
  mutate(avg_price = (open + close) / 2)
