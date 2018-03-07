source("will_wrangling.R")

ui <- navbarPage(theme = shinytheme("cosmo"),
  
           title = "Analyzing Cryptocurrency Trends and Events",
           
           
            tabPanel(h5("Spread Analysis"),
                      sidebarPanel(
                       dateInput("startdate", label = "Select start date:",
                                                start = "2013-04-28",
                                                min = "2013-04-28",
                                                max = "2018-02-05",
                                                # default value at 2017-01-01
                                                format = "yyyy-mm-dd", value = "2013-04-28"
                                          ),
                        dateInput("enddate", label = "Select end date:",
                                              start = "2013-04-28",
                                              min = "2013-04-28",
                                              max = "2018-02-05",
                                              # default value at 2017-01-01
                                              format = "yyyy-mm-dd", value = "2018-02-05"
                                        ),
                        selectInput("coinone", label = "Select coin to compare",
                                    choices = list.coins
                          
                          
                        ),
                        selectInput("cointwo", label = "Select coin to compare",
                                   choices = list.coins
                                   
                                   
                        )
                       
                      ),
                      mainPanel(
                        tabsetPanel(
                          type = "tabs",
                          
                          tabPanel("Spread Comparison Plot", plotOutput("spreadplot"),textOutput("spreadplot.info")),
                          
                          tabPanel("Spread Summary Table", tableOutput("spreadavgtable"),
                                   textOutput("avgtable.info"), tableOutput("avgfulltable")),
                          tabPanel("Scaled Spread Plot", plotOutput("scaledspreadplot"),textOutput("scaledspread.info"))
                          #                type = "tabs",
                          #                # output data...
                          #                tabPanel("Plot", plotOutput("plot"), textOutput("plot.info")),
                          #                tabPanel("Table", dataTableOutput("table"))
                          # 
                        )
                      )
                     
                     
                     )
           
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
)