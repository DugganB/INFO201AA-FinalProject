ui <- navbarPage(theme = shinytheme("cosmo"),
                 
    title = "Analyzing Cryptocurrency Trends and Events",
    
    # Page for Market Cap Analysis
    tabPanel(h5("Performance by Market Cap"),
             sidebarPanel(
               # Header
               tags$h4(class = "header", "Controls:", align = "center"),
               # Input for Market Cap vs. Price
               radioButtons('cut', label = "Subset currencies by:",
                            choiceNames = c("Market Cap (USD)", "Price (USD)"),
                            choiceValues = c(1, 2)
               ),
               # Input to select start date
               dateInput('market.date', label = "Select date:",
                         value = "2017-04-28",
                         min = "2013-04-28",
                         max = "2018-02-05",
                         format = "yyyy-mm-dd"
                         
               ),
               # Input to select date range
               sliderInput('market.range', label = "Range to display (in days):",
                           min = 30,
                           max =  365,
                           value = 30
               ),
               
               # Overview of Market Cap
               tags$p("The Market Cap, or market capitalization of a coin is widely regarded by
                      investors as an effective indicator of a coin's return on investment (ROI).
                      It is...", class = "guide"),
               tags$p("In general, market cap for a coin is calculated by:", class = "guide"),
               tags$p(strong("Market Cap = Supply x Price"), class = "guide"),
               # tags$p("Given the market prices and market caps for the top 100 ranked coins, how
               #        well does market cap actually predict ROI?", class = "guide"),
               tags$p("CoinMarketCap uses the total circulating supply (the number of coins
                      currently circulating in the market or in public hands) calculate the cap.",
                      class = "guide")
               
             ),
             
             # Main panel to display outputs
             mainPanel(
               
               tabsetPanel(
                 
                 type = "tabs",
                 
                 # dM/dt tab
                 tabPanel("dM/dt",
                          
                          plotOutput('dm_dt.plot'),
                          
                          plotOutput('market.plot'),
                          
                          plotOutput('price.plot')
                          
                          
                 ),
                 
                 # Rankings tab
                 tabPanel("Rankings",
                          
                          plotOutput('market.rank.plot')
                          
                 )
                 
               )
               
             )
             
    )
                 
)