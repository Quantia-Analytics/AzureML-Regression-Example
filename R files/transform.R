## This file contains the code for the transformation 
## of the raw bike rental data. it is intended to run in an 
## Azure ML Execute R Script module. By changing
## the following vaiable to false the code will run
## in R or RStudio.
Azure <- FALSE

## If we are in Azure, source the utilities from the zip
## file. The next lines of code read in the dataset, either 
## in Azure ML or from a csv file for testing purposes.
if(Azure){
  source("src/utilities.R")
  BikeShare <- maml.mapInputPort(1)
  BikeShare$dteday <- set.asPOSIXct(BikeShare)
}else{
  BikeShare <- read.csv("BikeSharing.csv", sep = ",", 
                        header = T, stringsAsFactors = F )
  
  ## Select the columns we need
  cols <- c("dteday", "mnth", "hr", "holiday",
            "workingday", "weathersit", "temp",
            "hum", "windspeed", "cnt")
  BikeShare <- BikeShare[, cols]
  
  ## Transform the date-time object
  BikeShare$dteday <- char.toPOSIXct(BikeShare)
  
  ## Normalize the numeric perdictors 
  cols <- c("temp", "hum", "windspeed") 
  BikeShare[, cols] <- scale(BikeShare[, cols])  
}

## Create a new variable to indicate workday
BikeShare$isWorking <- ifelse(BikeShare$workingday & 
                                !BikeShare$holiday, 1, 0)  

## Add a column of the count of months which could 
## help model trend. 
BikeShare <- month.count(BikeShare)

## Create an ordered factor for the day of the week 
## starting with Monday. Note this factor is then 
## converted to an "ordered" numerical value to be
## compatible with Azure ML table data types.
BikeShare$dayWeek <- as.factor(weekdays(BikeShare$dteday))
BikeShare$dayWeek <- as.numeric(ordered(BikeShare$dayWeek, 
                                        levels = c("Monday", 
                                                   "Tuesday", 
                                                   "Wednesday", 
                                                   "Thursday", 
                                                   "Friday", 
                                                   "Saturday", 
                                                   "Sunday")))

## Add a variable with unique values for time of day for working and non-working days.
BikeShare$workTime <- ifelse(BikeShare$isWorking, 
                             BikeShare$hr, 
                             BikeShare$hr + 24) 

## Shift the order of the hour variable so that it is smoothly
## "humped over 24 hours.
BikeShare$xformHr <- ifelse(BikeShare$hr > 4, 
                            BikeShare$hr - 5, 
                            BikeShare$hr + 19)

## Add a variable with unique values for time of day for working and non-working days.
BikeShare$xformWorkHr <- ifelse(BikeShare$isWorking, 
                             BikeShare$xformHr, 
                             BikeShare$xformHr + 24) 

## Output the transformed data frame if in Azure ML.
if(Azure) {
  maml.mapOutputPort('BikeShare')
} 