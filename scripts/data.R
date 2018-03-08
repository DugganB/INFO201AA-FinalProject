# read in data and select columns
data <- read.csv("crypto-markets100.csv", stringsAsFactors = FALSE)

# Filtered data for Market Cap
market.data.filter <- data %>% select(symbol, name, date, open, close, market, ranknow) %>%
                      filter(market != 0) %>% mutate(market = as.numeric(market)) %>%
                      mutate(avg_price = (open + close) / 2)