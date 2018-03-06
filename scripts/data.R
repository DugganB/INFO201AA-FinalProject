# read in data and select columns
data <- read.csv("crypto-markets100.csv", stringsAsFactors = FALSE)
data.filter <- select(data, symbol, name, date, open, close)

max.closing.btc <- data.filter %>%
    filter(close == max(close))
btc.max.eth <- data.filter %>%
    filter(symbol == "ETH") %>%
    filter(date == max.closing.btc$date)
