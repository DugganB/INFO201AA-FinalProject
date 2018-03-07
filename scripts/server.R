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
            ggtitle("Top 100 Cyrptos Closing Prices per day") +
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
}












