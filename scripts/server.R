library("dplyr")
library("ggplot2")
library("shiny")
library("plotly")


server <- function(input, output) {
    # filter data based off date chosen
    filterDataTrends <- reactive({
        data <- data.filter.trends %>%
            filter(date >= as.Date(input$date))
    })
    
    # renders a data table
    output$table.trends <- renderDataTable({
        return(filterDataTrends())
    })
    
    # renders a plot using the user's filtered data set
    output$plot.trends <- renderPlotly({
        ggplot(data = filterDataTrends()) +
            # use line plot grouping by symbol
            geom_line(aes(date, close, group=symbol, color=symbol)) +
            # adjust aesthetics of the plot
            ggtitle("Top 100 Cryptos Closing Prices per day") +
            labs(x = "Date", y = "Closing Price") +
            # remove ticks and textfor dates
            # dates are too long to be read and have too many points
            # users can use plotly's hover to find more information
            theme(axis.ticks.x = element_blank(),
                  axis.text.x = element_blank())
    })
    
    # Output write up about the visualization
    output$plot.info.trends <- renderText({
        # store filtered info into vars
        # these vars will be referenced inside the write up
        max.closing.btc <- data.filter.trends %>%
            filter(close == max(close))
        btc.max.eth <- data.filter.trends %>%
            filter(symbol == "ETH") %>%
            filter(date == max.closing.btc$date)
        btc.max.eth.week <- data.filter.trends %>%
            filter(symbol == "ETH") %>%
            filter(date == as.Date(max.closing.btc$date) - 7)
        eth.percent.diff <- (btc.max.eth.week$close / btc.max.eth$close) * 100
        btc.max.ltc <- data.filter.trends %>%
            filter(symbol == "LTC") %>%
            filter(date == max.closing.btc$date)
        btc.max.ltc.week <- data.filter.trends %>%
            filter(symbol == "LTC") %>%
            filter(date == as.Date(max.closing.btc$date) - 7)
        ltc.percent.diff <- (btc.max.ltc.week$close / btc.max.ltc$close) * 100
        return(paste0("Without even looking at any raw data, anyone that sees ",
                     "this line plot will see the strong influence that BTC ",
                     "has on the prices of all other coins. Observing the ",
                     "dataset more closely, we can see one key date that had ",
                     "the biggest influence on other tokens: ", max.closing.btc$date,
                     ". This date is where BTC saw it's maximum closing price ",
                     "in our dataset. We can also observe other coin prices on ",
                     "the same date. Ethereum saw a closing price of $",
                     btc.max.eth$close, ", an increase of ",
                     round(eth.percent.diff,0), "% from the week prior. Litecoin ",
                     "also saw a major increase on the same day with a price of $",
                     btc.max.ltc$close, ", an increase of ",
                     round(ltc.percent.diff,0), "% from the week prior. It's ",
                     "also very clear by just analzying the shape of the graph ",
                     "that the majority of the coins saw a spike in the space ",
                     "place as Bitcoin did."))
               })

    # 4 reactive variables for spread. start and end and 2 coin slugs
    spreadstartdate <- reactive({
      input$startdate
    })
    spreadenddate <- reactive({
      input$enddate
      
    })
    
    spreadcoin <- reactive({
      input$coinone
    })
    
    spreadcointwo <- reactive({
      input$cointwo
    })
    
    # Basic analysis of spread of two coins over a graph
    output$spreadplot <- renderPlot({
      plottitle <-paste0("Spread Analysis of ",as.character(spreadcoin())," and ", as.character(spreadcointwo()))
      data.spread <- CoinData(spreadcointwo(),spreadcoin(),spreadstartdate(),spreadenddate())
      ggplot(data = data.spread)+
        geom_line(aes(x = date, y = spread, group = slug, color = slug)) +
        ggtitle(plottitle)
    })
    # Corresponding explanation for basic spread graph
    output$spreadplot.info <-renderText({
      filteredcoinone <- filter(data.100, slug == spreadcoin())
      filteredcointwo <- filter(data.100, slug == spreadcointwo())
      # as.character(spreadcoin())
      # as.character(spreadcointwo())
      paste0("This plot compares the spreads of ",spreadcoin(), " and ", spreadcointwo(),
             ". Any flat areas can be explained by the difference in the scale of the two coins",
             " and are not necessarily just a spread of 0 but a spread that is too small for the plot scale. ",
             spreadcoin(), " has a peak spread of: ", max(filteredcoinone$spread),". Whereas ",
             spreadcointwo(), " has a peak spread of: ", max(filteredcointwo$spread), 
             ". Sections may be missing due to missing data (the coin wasn't recorded for a time)")
    })
    
    
    # Spread statistical summary table for two specific coins between start and end date.
    output$spreadavgtable <- renderTable({
      sumtable <- SumYear(spreadstartdate(),spreadenddate(),spreadcoin(),spreadcointwo())
      return(sumtable)
      
    })
    # Full spread statistical summary table for all top 100 coins between start and end date.
    output$avgfulltable <- renderTable({
     sumfulltable <- TableSum(spreadstartdate(),spreadenddate())
    })
    # Corresponding explanation of summary table
    output$avgtable.info <- renderText({
      paste0("The above content is based on the selected information (start and end date, 2 specific coins.", 
             " A lot of coins are missing for earlier years as coinmarketcap didn't track them back then.",
             " The information below is more generally based on the start and end date for all top 100 coins (in alphabetical order).",
             " The IQR is the interquartile range, which is the middle 50%(from 25% - 75%) of the data .",
             " The stDev is the standard deviation is a measurement of the variation in the data set.")
    })
    # Plot of scaled price and spread of 2 coins. Scaled price to top price of coin within date interval.
    # Scaled spread to top spread of coin within spread interval
    output$scaledspreadplot <- renderPlot({
      plottitle <-paste0("Scaled Comparison of ",as.character(spreadcoin())," and ", as.character(spreadcointwo()))
      scaled.df <- ScaleSpread(spreadstartdate(),spreadenddate(),spreadcoin(),spreadcointwo())
      ggplot(data = scaled.df) +
        geom_line (aes(x = scaled.price, y= scaled.spread, group = slug, color = slug)) +
        ggtitle(plottitle)
    })
    # Text explanation of scaled graph
    output$scaledspread.info <-renderText({
      filteredcoinone <- filter(data.100, slug == spreadcoin())
      filteredcointwo <- filter(data.100, slug == spreadcointwo())
      paste0("This graph compares the spread of ", as.character(spreadcoin()), " and ", as.character(spreadcointwo()),
             " putting both on their own scale to emphasize spread on the coin's scale. For example, ", 
             as.character(spreadcoin()), " is divided by its peak spread of ", max(filteredcoinone$spread), 
             " for spread and divided by its peak value of $", max(filteredcoinone$high),
             " for value. This puts both coins on a scale of 0-1 to be able to perceive the ","
             differences in increases and decreases in spread as the prices change. We can see how ","
             there are general increases and decreases in spread between the coins, but there is also a differing",
             " amount of increase for the coins, as well as differing events that may correlate to different ","
             increases and decreases.","Since most of the more massive changes in spread were all",
             " around the same time, there is very little change until mid-late 2017 if you change the calendar.")
    })
    output$data.explanation <- renderText({
      paste0("Our dataset explores cryptocurrency. More specifically, it gives some basic ",
        "information regarding tokens for every day and from April 28th 2017 to February 6th 2018 ",
        "(with new updates every few weeks). The data was gained through scraping CoinMarketCap, ",
        "a site that tracks various coins, and converting the information into a dataframe. ",
        "This dataset was built with R and heavily enhanced to be compatible with CRAN. ",
        "It's currently still a github project that's in the works of being published by CRAN. ",
        "This was mainly created by Jesse Vent, a data analyst in Australia.
    There are observations of 1,382 different crypto tokens (i.e. bitcoin, ethereum, etc). ",
        "It has 13 column variables: slug, symbol, name, date, ranknow (ranking), open ",
        "(the day's starting value), high, low, close (the day's closing value), volume(in circulation)",
        ", market, close_ratio, and spread (high-low difference). In total, there are 649,051 observations. ",
        "This gives a very thorough dataset on the basic concepts involving cryptocurrencies. ",
        "From this perspective, it's not necessary to understand the technical capability of a ",
        "coin, but merely the monetary value of it.
        
    We will be analyzing trends involving cryptocurrency, and trying to relate them to each other, and real world events.",
        " These trends will help us recognize and understand the nature of cryptocurrency."
        )
    })
    
    crashname <- reactive({
      input$Crash
    })
    
    crashCoin <- reactive({
      input$coin
    })
    
    output$crashPlot <- renderPlot({
      plottitle <-paste0("The Crash of ",as.character(crashname())," showing ", as.character(crashCoin()))
      data.crash <- coinTimeFrame(crashstartdate(crashname()),crashenddate(crashname()),crashCoin())
      ggplot(data = data.crash)+
        geom_line(aes(x = date, y = open, group = slug, color = slug)) +
        ggtitle(plottitle)
    })
    
    output$crashtable.info <- renderText({
      paste0("This is a table summarizing the statistics for this crash. If numbers show up as NaN or 0 that is because the dataset", 
             " is not perfect")
    })
    
    output$crashTable <- renderTable({
      crashTable <- coinDropSummary(crashstartdate(crashname()),crashenddate(crashname()))
    })
    
    output$crashplot.info <- renderText({
      getCrashInfo(crashname(), crashCoin())
    })

    #### Market Cap ####
    
    # The end date for selecting market cap data
    market.end.date <- reactive ({
      as.Date(input$market.date) + input$market.range
    })
    
    # Filter initial market data based on date
    market.data <- reactive ({
      market.data.filter %>% filter(date >= input$market.date &
                                      date <= market.end.date()) %>%
        group_by(name) %>% filter(first(date) <= input$market.date + 15) %>% ungroup()
    })
    
    # Filter data for market growth
    market.growth <- reactive ({
      data <- market.data() %>% group_by(name) %>%
        filter(date == first(date) | date == last(date)) %>%
        mutate(net_market = last(market) - first(market),
               avg_market = (last(market) + first(market) / 2),
               market_price = (last(market) + first(market) / 2)) %>%
        mutate(net_market_pct = net_market / first(market))
      data <- data %>% select(name, avg_market, net_market_pct, market_price) %>%
        unique()
      
      return(data)
    })
    # Plot growth data
    output$growth.plot <- renderPlot({
      ggplot(market.growth(), aes(x = avg_market, y = net_market_pct)) +
        geom_point(aes(color = market_price), size = 4) +
        labs(x = "Average Market Cap (USD)", y = "Percent Growth over Interval") +
        scale_x_continuous(labels = scales::dollar, trans = "sqrt") +
        scale_y_continuous(labels = scales::percent) +
        scale_color_gradient(low="orange", high="yellow",
                             labels = scales::dollar) +
        # Set font sizes
        theme(axis.title.x = element_text(size = 12, face = "bold"),
              axis.title.y = element_text(size = 12, face = "bold"),
              legend.text = element_text(size = 10))
    })
    
}