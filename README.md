# Analyzing Cryptocurrency Trends and Events

## Application: https://kylerws.shinyapps.io/info201aa-finalproject/

## Dataset
Our [dataset](https://www.kaggle.com/jessevent/all-crypto-currencies) explores cryptocurrency. More specifically, it gives some basic information regarding tokens for every day and from April 28th 2017 to February 6th 2018 (with new updates every few weeks). The data was gained through scraping [CoinMarketCap](https://coinmarketcap.com/), a site that tracks various coins, and converting the information into a dataframe. This dataset was built with R and heavily enhanced to be compatible with CRAN. It's currently still a github project that's in the works of being published by CRAN. This was mainly created by [Jesse Vent](https://www.kaggle.com/jessevent), a data analyst in Australia.

There are observations of 1,382 different crypto tokens (i.e. bitcoin, ethereum, etc). It has 13 column variables: slug, symbol, name, date, ranknow (ranking), open (the day's starting value), high, low, close (the day's closing value), volume(in circulation), market, close_ratio, and spread (high-low difference). In total, there are 649,051 observations. This gives a very thorough dataset on the basic concepts involving cryptocurrencies. From this perspective, it's not necessary to understand the technical capability of a coin, but merely the monetary value of it. We will be analyzing trends involving cryptocurrency, and trying to relate them to each other, and real world events. These trends will help us recognize and understand the nature of cryptocurrency.

## Questions Analyzed
1. How does the spread (USD difference) vary between coins? How does this spread vary as prices increase or decrease (in terms of the individual coin and the value of bitcoin at the time.)?
2. When Bitcoin (BTC) sees a downtrend do other coins also see similar patterns? What about uptrends?
3. What uptrends and downtrends are linked to real world developments? (Forks, regulations, etc).  Are there artificial trends in the market (whales)? What percentage of these trends are artificial?
4. During ‘big’ crashes or corrections how long does it take for a price recovery to take place? Is there any pattern that can be seen from the decrease in price compared to how long it stays below the all time high?
