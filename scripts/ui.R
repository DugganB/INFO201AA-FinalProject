ui <- navbarPage(theme = shinytheme("cosmo"),

title = "Analyzing Cryptocurrency Trends and Events"
tabPanel(h5("Old"),
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
			plotlyOutput("plot.trends"),
			textOutput("plot.info.trends")
		)
	)
)