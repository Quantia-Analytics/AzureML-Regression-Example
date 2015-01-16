## This code removes downside outliers from the 
## training sample of the bike rental data. 
## The value of Quantile variable can be changed 
## to change the trim level. This code is s intended 
## to run in an Azure ML Execute R Script module. 
## By changing some comments you can test the code 
## in RStudio.

## Read in the dataset. 
BikeShare <- maml.mapInputPort(1)

## Build a dataframe with the quantile by month and 
## hour. Parameter Quantile determines the trim point. 
Quantile <- 0.10
library(dplyr)
BikeShare$dteday <- as.character(BikeShare$dteday)
quantByPer <- (
  BikeShare %>%
    group_by(workTime, monthCount) %>%
    summarise(Quant = quantile(cnt, 
                               probs = Quantile, 
                               na.rm = TRUE)) 
 )

## Create a data frame to hold the logical vector
## indexed by monthCount and hr.
indFrame <- data.frame(
  workTime = BikeShare$workTime,
  monthCount = BikeShare$monthCount,
  ind = rep(TRUE, nrow(BikeShare))
  )

## Need to loop through all months and hours since
## these are now randomized by the sample. Memory for 
## the data frame is allocated so this in-place 
## operation should not be too slow. 
for(month in 1:48){
  for(hour in 0:47){
    indFrame$ind[indFrame$workTime == hour & 
                   indFrame$monthCount == month] <- 
      BikeShare$cnt[BikeShare$workTime == hour & 
                      BikeShare$monthCount == month] > 
      quantByPer$Quant[quantByPer$workTime == hour & 
                         quantByPer$monthCount == month]
  }
}

BikeShare$dteday <- as.POSIXct(strptime(paste(
    BikeShare$dteday, "00:00:00", sep = ""), 
  "%Y-%m-%d %H:%M:%S"))
## Filter the rows we want.
BikeShare <- BikeShare[indFrame$ind, ] 

## Output the transformed data frame.
maml.mapOutputPort('BikeShare')