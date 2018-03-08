server <- function(input, output) {
    
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