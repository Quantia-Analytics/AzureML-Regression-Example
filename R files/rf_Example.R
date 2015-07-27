## This code is demonstrates the use of the importance
## from a randomForest model to select features.

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
  require(dplyr)
  BikeShare <- mutate(BikeShare, casual = NULL, 
                      registered = NULL, instant = NULL,
                      atemp = NULL)
}

require(randomForest)
rf.mod <- randomForest(cnt ~ . - count
                       - mnth
                       - hr
                       - workingday
                       - isWorking
                       - dayWeek
                       - xformHr
                       - workTime
                       - holiday
                       - windspeed
                       - monthCount
                       - weathersit, 
                       data = BikeShare2, 
                       ntree = 100, nodesize = 10,
                       importance = TRUE)

varImpPlot(rf.mod)

out.frame <- BikeShare[, c("cnt", rownames(rf.mod$importance))]

if(Azure) maml.mapOutputPort("out.frame")
