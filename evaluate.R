## This code will produce various measures of model performance using the 
## actual and predicted values from the Bike rental data. 
## This code is s intended to run in an Azure ML Execute R 
## Script module. By changing some comments you can test the code in RStudio.

## Source the zipped utility file
source("src/utilities.R")

## Read in the dataset if in Azure ML.
## The second and third line are for test in RStudio and should be 
## commented out if running in Azure ML. 
inFrame <- maml.mapInputPort(1)
#inFrame <- outFrame[, c("actual", "predicted")]
#refFrame <- BikeShare

## Another data frame is created from the data produced
## by the Azure Split module. The columns we need are 
## added to inFrame
## Comment out the next line when running in RStudio.
refFrame <- maml.mapInputPort(2)
inFrame[, c("dteday", "monthCount", "hr")] <- refFrame[, c("dteday", "monthCount", "hr")]

## Assign names to the data frame for easy reference
names(inFrame) <- c("cnt", "predicted", "dteday", "monthCount", "hr")

## Since the model was computed using the log of bike demand
## transform the results to actual counts.
inFrame[ , 1:2] <- lapply(inFrame[, 1:2], exp)

## If running in Azure ML uncomment the following line to create a character
## representation of the POSIXct Datetime object. This is required since
## R will interpret the Azure DateTime type as POSIXct. 
inFrame$dteday <- get.date(inFrame$dteday)

## A POSIXct time series object for the x axis of the time series plots.
inFrame$Time <- POSIX.date(inFrame$dteday, inFrame$hr)

## Since the sampling process randomized the order of the rows
## sort the data by the Time object.
inFrame <- inFrame[order(inFrame$Time),]

# Time series plots showing actual and predicted values; columns 3 and 4. 
times <- c(7, 9, 12, 15, 18, 20, 22)
lapply(times, function(x){
  plot(inFrame$Time[inFrame$hr == x], 
     inFrame$cnt[inFrame$hr == x], type = "l",
     xlab = "Date", ylab = "Number of bikes used",
     main = paste("Bike demand at ",as.character(x), ":00", spe =""));
  lines(inFrame$Time[inFrame$hr == x], 
        inFrame$predicted[inFrame$hr == x], type = "l", col = "red")} )

## Box plots of the residuals by hour
library(ggplot2)
inFrame$resids <-  inFrame$predicted - inFrame$cnt
ggplot(inFrame, aes(x = as.factor(hr), y = resids)) + geom_boxplot( ) +
  ggtitle("Residual of actual versus predicted bike demand vs hour")

library(dplyr)
## First compute and display the median residual by hour
evalFrame <- inFrame %>%
    group_by(hr) %>%
    summarise(medResidByHr = format(round(median(predicted - cnt), 2), nsmall = 2)) 

## Next compute and display the median residual by month
tempFrame <- inFrame %>%
    group_by(monthCount) %>%
    summarise(medResid = median(predicted - cnt)) 

evalFrame$monthCount <- tempFrame$monthCount
evalFrame$medResidByMcnt <- format(round(tempFrame$medResid, 2), nsmall = 2)

print("Breakdown of residuals")
evalFrame

