## This code will produce various measures of model 
## performance using the actual and predicted values 
## from the Bike rental data. 
## This code is intended to run in an Azure ML 
## Execute R Script module. By changing the Azure
## variable to false you can run in R or
## RStudio.
Azure <- FALSE

if(Azure){
  ## Source the zipped utility file
  source("src/utilities.R")
  ## Read in the dataset if in Azure ML.
  ## The second and third line are for test in RStudio 
  ## and should be commented out if running in Azure ML. 
  inFrame <- maml.mapInputPort(1)
  refFrame <- maml.mapInputPort(2)
  refFrame$dteday <- set.asPOSIXct2(refFrame)
}else{
  inFrame <- outFrame[, c("actual", "predicted")]
  refFrame <- BikeShare
}

## Another data frame is created from the data produced
## by the Azure Split module. The columns we need are 
## added to inFrame
inFrame[, c("dteday", "monthCount", "hr", "xformWorkHr")] <- 
  refFrame[, c("dteday", "monthCount", "hr", "xformWorkHr")]

## Assign names to the data frame for reference
names(inFrame) <- c("cnt", "predicted", "dteday", 
                    "monthCount", "hr", "xformWorkHr")

## Since the sampling process randomized the order of 
## the rows sort the data by the Time object.
inFrame <- inFrame[order(inFrame$dteday),]

## Time series plots showing actual and predicted values; columns 3 and 4. 
library(ggplot2)
times <- c(7, 9, 12, 15, 18, 20, 22)

lapply(times, function(times){
  ggplot() +
    geom_line(data = inFrame[inFrame$hr == times, ], 
              aes(x = dteday, y = cnt)) +
    geom_line(data = inFrame[inFrame$hr == times, ], 
              aes(x = dteday, y = predicted), color = "red") +
    ylab("Log number of bikes") +
    labs(title = paste("Bike demand at ",
                       as.character(times), ":00", spe ="")) +
    theme(text = element_text(size=20))
})

## Compute the residuals
library(dplyr)
inFrame <-  mutate(inFrame, resids = predicted - cnt)

## Plot the residuals. First a histogram and 
## a qq plot of the residuals.
ggplot(inFrame, aes(x = resids)) + 
  geom_histogram(binwidth = 1, fill = "white", color = "black")

qqnorm(inFrame$resids)
qqline(inFrame$resids)

## Plot the residuals by hour and transformed work hour.
inFrame <- mutate(inFrame, fact.hr = as.factor(hr),
                  fact.xformWorkHr = as.factor(xformWorkHr))                                  
facts <- c("fact.hr", "fact.xformWorkHr") 
lapply(facts, function(x){ 
       ggplot(inFrame, aes_string(x = x, y = "resids")) + 
         geom_boxplot( ) + 
         ggtitle("Residual of actual versus predicted bike demand by hour")})


## First compute and display the median residual by hour
evalFrame <- inFrame %>%
    group_by(hr) %>%
    summarise(medResidByHr = format(round(
        median(predicted - cnt), 2), 
      nsmall = 2)) 

## Next compute and display the median residual by month
tempFrame <- inFrame %>%
    group_by(monthCount) %>%
    summarise(medResid = median(predicted - cnt)) 

evalFrame$monthCount <- tempFrame$monthCount
evalFrame$medResidByMcnt <- format(round(
    tempFrame$medResid, 2), 
  nsmall = 2)

print("Breakdown of residuals")
print(evalFrame)

## Output the evaluation results
outFrame <- data.frame(evalFrame)
if(Azure) maml.mapOutputPort('outFrame')

