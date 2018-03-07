library("dplyr")
library("ggplot2")
library("shiny")
source("will_wrangling.R")

server <- function(input, output) {
    
    
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
    
    
    output$spreadplot <- renderPlot({
      plottitle <-paste0("Spread Analysis of ",as.character(spreadcoin())," and ", as.character(spreadcointwo()))
      data.spread <- CoinData(spreadcointwo(),spreadcoin(),spreadstartdate(),spreadenddate())
      ggplot(data = data.spread)+
        geom_line(aes(x = date, y = spread, group = slug, color = slug)) +
        ggtitle(plottitle)
    })
    
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
    
    output$spreadavgtable <- renderTable({
      sumtable <- SumYear(spreadstartdate(),spreadenddate(),spreadcoin(),spreadcointwo())
      return(sumtable)
      
    })
    output$avgfulltable <- renderTable({
     sumfulltable <- TableSum(spreadstartdate(),spreadenddate())
    })
    output$avgtable.info <- renderText({
      paste0("The above content is based on the selected information (start and end date, 2 specific coins.", 
             " A lot of coins are missing for earlier years as coinmarketcap didn't track them back then.",
             " The information below is more generally based on the start and end date for all top 100 coins (in alphabetical order).",
             " The IQR is the interquartile range, which is the middle 50%(from 25% - 75%) of the data .",
             " The stDev is the standard deviation is a measurement of the variation in the data set.")
    })
    
    output$scaledspreadplot <- renderPlot({
      plottitle <-paste0("Scaled Comparison of ",as.character(spreadcoin())," and ", as.character(spreadcointwo()))
      scaled.df <- ScaleSpread(spreadstartdate(),spreadenddate(),spreadcoin(),spreadcointwo())
      ggplot(data = scaled.df) +
        geom_line (aes(x = scaled.price, y= scaled.spread, group = slug, color = slug)) +
        ggtitle(plottitle)
    })
    
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
    
    # filter data based off date chosen
    # filterData <- reactive({
    #     data <- data.filter %>%
    #         filter(date >= as.Date(input$date))
    # })
    # output$table <- renderDataTable({
    #     return(filterData())
    # })
    
    # output$plot <- renderPlot({
    # 
    # })
      # ggplot(data = filterData()) +
      #     # use line plot grouping by symbol
      #     geom_line(aes(date, close, group=symbol, color=symbol)) +
      #     # clean up style
      #     ggtitle("Closing prices") +
      #     labs(x = "Date", y = "Closing Price")    
    # output$plot.info <- renderText({
    #     max.closing.btc <- data.filter %>%
    #         filter(close == max(close))
    #     btc.max.eth <- data.filter %>%
    #         filter(symbol == "ETH") %>%
    #         filter(date == max.closing.btc$date)
    #     
    #     return(paste0("Without even looking at any raw data, anyone that sees ",
    #                  "this line plot will see the strong influence that BTC ",
    #                  "has on the prices of all other coins. Observing the ",
    #                  "dataset more closely, we can see one key date that had ",
    #                  "the biggest influence on other tokens: ", max.closing$date,
    #                  ". This date is where BTC saw it's maximum closing price ",
    #                  "in our dataset. We can also observe other coin prices on ",
    #                  "the same date. "))
    # })
}












