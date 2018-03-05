# read in data and select columns
data <- read.csv("crypto-markets100.csv", stringsAsFactors = FALSE)
data.filter <- select(data, symbol, name, date, open, close)