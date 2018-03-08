server <- function(input, output) {
    
    #### Market Cap ####
    
    # The end date for selecting market cap data
    market.end.date <- reactive ({
      as.Date(input$market.date) + input$market.range
    })
  
    # Select Market Cap data based on date
    market.data <- reactive ({
      market.data.filter %>% filter(date >= input$market.date &
                                    date <= market.end.date())
    })
    
    # Cut by price
    # m.data.price <- reactive ({
    #   market.data() %>% price
    # })
    
    # Cut by marke cap

    
    # # Breaks for date axis
    # date.breaks <- reactive({
    #   seq(from = input$market.date,
    #       to = market.end.date(),
    #       length.out = 10)
    # })
    
    # Filters dm_dt data
    dm_dt.data <- reactive ({
      data <- market.data() %>% mutate(date_interval = cut(as.Date(date), "week")) %>%
              group_by(date_interval, name)
      
      data <- data %>% mutate(first = first(market), last = last(market))
      data <- data %>% summarise(dt = length(date_interval)) %>%
              right_join(data, by = c("date_interval", "name")) %>% mutate(dm = (last - first) / dt)
      return(data)
    })
    
    dm_dt.ranking <- reactive ({
      # Select unique dm_dt values for all coins at each date interval
      data <- dm_dt.data() %>% select(date_interval, name, dm, dt) %>% unique() %>% ungroup()
      data <- data %>% split(as.factor(data$name))  # split data by coin
      data.list <- lapply(data, parse.dm_dt)        # parse to list of data frames
      
      # Join and return
      return(Reduce(function(x, y) full_join(x, y, by = "date_interval"), data.list))
    })
    
    # Parses a tibble of coin dm_dt data and returns a data frame
    # organized by date interval
    #
    # data is a tibble with columns date.interval, name, dm, dt
    parse.dm_dt <- function(data) {
      coin <- data$name %>% first()                   # save coin name
      data <- data[ , names(data) != "name"] %>%      # convert to data frame
              as.data.frame()
      colnames(data) <- c("date_interval",
                          paste0(coin, "_dm"),
                          paste0(coin, "_dt"))
      return(data)
    }
    
    # Plot closing price
    output$price.plot <- renderPlot({
      ggplot(market.data(), aes(x = as.Date(date), y = close, group = name, color = name)) +
        geom_line() +
        #scale_x_date(date_breaks = "1 week") +
        theme(legend.position = "none")

    })
    
    # Plot dm_dt
    output$dm_dt.plot <- renderPlot({
      ggplot(dm_dt.data(), aes(x = date_interval, y = dm, group = name, color = name)) +
        geom_line() +
        # scale_y_log10() +
        labs(title = "Change in Market Cap by Week",
             x = "Week (by start date)",
             y = "Change in Market Cap (USD)") +
        scale_y_continuous(labels = scales::dollar) +
        theme(legend.position = "none")
      
    })
    
    
    # output$market.rank.plot <- renderPlot ({
    #   ggplot(dm_dt.ranking(), aes(x = ))
    # })
    
    # Plot market cap
    output$market.plot <- renderPlot({
      ggplot(market.data(), aes(x = date, y = market, group = name, color = name)) +
        geom_line() +
        # scale_y_log10() +
        theme(legend.position = "none")
    })
    
    output$market.info <- renderText({
      return(paste0("The Market Cap, or market capitalization of a coin is regarded by, ",
                    "investors as one of the best means of estimating a coin's return on ",
                    "investment (ROI). It is widely touted as ...",

                    "Given the market prices and market caps for the top 100 ranked coins, ",
                    "how well does market cap actually predict ROI?",

                    "In general, market cap for a coin is calculated by ",
                    
                    "Market Cap = Supply x Price",

                    "Our dataset draws its observtions from CoinMarketCap, which uses ",
                    "the total circulating supply (number of coins currently circulating ",
                    "in the market or in public hands) to calculate the cap."))
    })
    
}