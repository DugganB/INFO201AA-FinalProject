# Read in CSV files and ignore strings as factors
library("dplyr")
data <- read.csv("crypto-markets.csv", stringsAsFactors = FALSE)
data <- data %>%
    filter(ranknow <= 100)
write.csv(data, file = "crypto-markets100.csv")


# filter for results for CO2 emissions in metric tons
data.filter <- filter(data, Series.Code == "EN.ATM.CO2E.PC")

# get world shape file
world <- map_data("world")
iso.codes.world <- iso.alpha(world$region, n = 3)
# add col with iso codes to standardize
world <- mutate(world, iso = iso.codes.world)

# merge world and data.filter
data.combined <- left_join(data.filter, world, by = c("Country.Code" = "iso"))