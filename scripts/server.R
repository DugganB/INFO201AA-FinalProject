server <- function(input, output) {
    # filter data based off date chosen
    filterData <- reactive({
        data <- data.filter %>%
            filter(date >= as.Date(input$date))
    })
    output$table <- renderDataTable({
        return(filterData())
    })
    
    output$plot <- renderPlot({
        ggplot(data = filterData()) +
            # use line plot grouping by symbol
            geom_line(aes(date, close, group=symbol, color=symbol)) +
            # clean up style
            ggtitle("Closing prices") +
            labs(x = "Date", y = "Closing Price") +
            theme(axis.text.x = element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.text.y = element_blank(),
                  axis.ticks.y = element_blank())
    })
    
    output$plot.info <- renderText({
        max.closing.btc <- data.filter %>%
            filter(close == max(close))
        btc.max.eth <- data.filter %>%
            filter(symbol == "ETH") %>%
            filter(date == max.closing.btc$date)
        
        return(paste0("Without even looking at any raw data, anyone that sees ",
                     "this line plot will see the strong influence that BTC ",
                     "has on the prices of all other coins. Observing the ",
                     "dataset more closely, we can see one key date that had ",
                     "the biggest influence on other tokens: ", max.closing$date,
                     ". This date is where BTC saw it's maximum closing price ",
                     "in our dataset. We can also observe other coin prices on ",
                     "the same date. "))
    })
}












