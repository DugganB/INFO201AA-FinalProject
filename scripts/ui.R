ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            # allow user to select starting date
            # limit choices to valid ranges according to dataset
            dateInput("date", label = "Select date:",
                      start = "2013-04-28",
                      min = "2013-04-28",
                      max = "2018-02-05",
                      # default value at 2017-01-01
                      format = "yyyy-mm-dd", value = "2017-01-01")
        ),
        mainPanel(
            # divide into different tabs
            tabsetPanel(
                type = "tabs",
                # output data...
                tabPanel("Plot", plotOutput("plot")),
                tabPanel("Table", dataTableOutput("table"))
            )
        )
    )
)