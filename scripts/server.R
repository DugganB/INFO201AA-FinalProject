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
}












