ui <- navbarPage(theme = shinytheme("cosmo"),
           
    title = "Analyzing Cryptocurrency Trends and Events",
    
    # Page for Market Cap Analysis
    tabPanel(h5("Performance by Market Cap"),

             tags$h2(class = "guide", strong("Market Cap as an Indicator of Growth"),
                     align = "center", style = "padding: 0; overflow: hidden"),
             
             sidebarPanel(

               # Input to select start date
               dateInput('market.date', label = "Select starting date:",
                         value = "2017-06-01",
                         min = "2013-04-28",
                         max = "2018-02-05",
                         format = "yyyy-mm-dd"
                         
               ),
               # Input to select date range
               sliderInput('market.range', label = "Range to track over (in days):",
                           min = 30,
                           max =  365,
                           value = 30
               ),
               
               # Dividing line
               tags$hr(),
               
               # Overview of Market Cap
               tags$p("Market Cap, or market capitalization, measures the total market
                      value of a cryptocurrency. It is considered by some investors to be the most
                      important indicator of a coin's return on investment (ROI).", class = "guide"),
               tags$p("In general, market cap for a coin is calculated by:", class = "guide"),
               tags$p(strong("Market Cap = Supply x Price"), class = "guide"),
               # tags$p("Given the market prices and market caps for the top 100 ranked coins, how
               #        well does market cap actually predict ROI?", class = "guide"),
               tags$p("CoinMarketCap uses the total circulating supply (the number of coins
                      currently in circulation) to calculate the cap.",
                      class = "guide")
               
             ),
             
             # Main panel to display outputs
             mainPanel(
               tags$h3("Net Percent Change: Market Cap vs. Price", class = "header"),
               
               plotOutput('growth.plot'),
               
               tags$p("The market cap of a coin does appear to be a good indicator of
                      its potential growth. Taking a look at the scatterplot, far more net growth
                      is seen at lower market caps. Relatively obscure coins may see large swells
                      of 600% growth. Though their market price is low, the potential to see large
                      gains is greater.", class = "guide"),
               tags$p("In particular, coins like Bitcoin (Which sits at the very top in 
                      almost all metrics) tend", strong("not"), "to see big fluctations
                      in price, unless a market correction happens.
                      Smaller coins tend to see higher growth as their low market cap can lead
                      to higher volatility. For investors, this can mean better returns.",
                      class = "guide")
               
             )
                 
            )

)