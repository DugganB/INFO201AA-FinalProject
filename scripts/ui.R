ui <- navbarPage(theme = shinytheme("cosmo"),
  
                 title = "Analyzing Cryptocurrency Trends and Events",
                 
                 # tabPanel(h5("Old"),
                 #          sidebarPanel(
                 #            
                 #          # allow user to select starting date
                 #          # limit choices to valid ranges according to dataset
                 #          dateInput("date", label = "Select date:",
                 #                start = "2013-04-28",
                 #                min = "2013-04-28",
                 #                max = "2018-02-05",
                 #                # default value at 2017-01-01
                 #                format = "yyyy-mm-dd", value = "2017-01-01")
                 #          ),
                 #          
                 #          mainPanel(
                 #              # divide into different tabs
                 #              tabsetPanel(
                 #                type = "tabs",
                 #                # output data...
                 #                tabPanel("Plot", plotOutput("plot"), textOutput("plot.info")),
                 #                tabPanel("Table", dataTableOutput("table"))
                 #      )
                 #  )
                 
                 tabPanel(h5("Market Cap"),
                          
                          sidebarPanel(
                            # dateInput('start_date', label = "Select start date:",
                            #           value = "2013-04-28",
                            #           min = "2013-04-28",
                            #           max = "2018-02-05",
                            #           format = "yyyy-mm-dd"
                            #           
                            # ),
                            
                            dateRangeInput('market.range', label = "Select date range:",
                                           start = "2018-01-05",
                                           end = "2018-02-05",
                                           min = "2013-04-28",
                                           max = "2018-02-05",
                                           format = "yyyy-mm-dd")
                            
                          ),
                          
                          mainPanel(
                            plotOutput('price.plot'),
                            plotOutput('market.plot')
                          )
                          
                 )
                 
)