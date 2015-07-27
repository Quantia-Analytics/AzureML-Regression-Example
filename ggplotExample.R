## This code demonstrates some basic features of the 
## ggplot2 package.

## This code is intended to run in an Azure ML Execute R 
## Script module. By changing the following variable
## you can run the code in R or RStudio for testing.
Azure <- FALSE

if(Azure){
  source("src/utilities.R")
  BikeShare <- maml.mapInputPort(1)
  BikeShare$dteday <- set.asPOSIXct(BikeShare)
}else{
  BikeShare <- read.csv("BikeSharing.csv", sep = ",", 
                        header = T, stringsAsFactors = F )
  BikeShare$dteday <- char.toPOSIXct(BikeShare)
}

require(dplyr)
BikeShare <- BikeShare %>% filter(hr == 9)

require(ggplot2)
ggplot(BikeShare, aes(x = dteday, y = cnt)) +
  geom_line() +
  ylab("Number of bikes") +
  xlab("Time") +
  ggtitle("Bike demand at 0900") +
  theme(text = element_text(size=20))
