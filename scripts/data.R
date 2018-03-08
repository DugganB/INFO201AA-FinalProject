# read in data and select columns
data <- read.csv("crypto-markets100.csv", stringsAsFactors = FALSE)

# Filtered data for Market Cap
market.data.filter <- data %>% select(symbol, name, date, open, close, market) %>%
                      filter(market != 0) %>% mutate(market = as.numeric(market))

#### Work FLow ####

# Display category

# User asks for weekly, yearly, lifetime

# Calculate dm/dt
# Calculate over pos neg -> rating

# Offer top 25, bottom etc... vs. coin rank


