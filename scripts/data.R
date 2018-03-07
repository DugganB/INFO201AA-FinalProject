# read in data and select columns
data <- read.csv("crypto-markets100.csv", stringsAsFactors = FALSE)

# Market Cap
data.filter <- data %>% select(symbol, name, date, open, close, market)
# data.filter <- data.filter %>% filter(name != "Bitcoin")
data.filter <- data.filter %>% filter(market != 0)
data.filter <- data.filter %>% mutate(market = as.numeric(market))