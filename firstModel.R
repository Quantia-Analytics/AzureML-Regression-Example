## This file contains the code to create a basic 
## randomForest model in an Azure ML Create Model module.

## Some utility functions
set.asPOSIXct <- function(inFrame) { 
  dteday <- as.POSIXct(
    as.integer(inFrame$dteday), 
    origin = "1970-01-01")
  
  as.POSIXct(strptime(
    paste(as.character(dteday), 
          " ", 
          as.character(inFrame$hr),
          ":00:00", 
          sep = ""), 
    "%Y-%m-%d %H:%M:%S"))
}

char.toPOSIXct <-   function(inFrame) {
  as.POSIXct(strptime(
    paste(inFrame$dteday, " ", 
          as.character(inFrame$hr),
          ":00:00", 
          sep = ""), 
    "%Y-%m-%d %H:%M:%S")) }

## This code is intended to run in an 
## Azure ML Execute R Script module. By changing
## the following vaiable to false the code will run
## in R or RStudio.
Azure <- FALSE

## Set the dteday column to a POSIXct type if in Azure ML
## or bind the data to the dataset name.
if(Azure){
  dataset$dteday <- set.asPOSIXct(dataset)
}else{
  dataset <- read.csv("BikeSharing.csv", sep = ",", 
                        header = T, stringsAsFactors = F )
  dataset$dteday <- char.toPOSIXct(dataset)
}

require(randomForest)
model <- randomForest(cnt ~ xformWorkHr + dteday +
                        temp + hum, 
                      data = dataset, ntree = 40, 
                      nodesize = 5)