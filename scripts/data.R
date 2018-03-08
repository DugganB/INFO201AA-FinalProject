# read in data and select columns
data <- read.csv("crypto-markets100.csv", stringsAsFactors = FALSE)
data.filter.trends <- select(data, symbol, name, date, open, close)


# Grabbing the data from csv and then grabbing the top 100 data.
data.raw <- read.csv("crypto-markets.csv", stringsAsFactors = FALSE)

data.100 <- filter(as.data.frame(data.raw, stringsAsFactors = FALSE), ranknow <= 100)


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
