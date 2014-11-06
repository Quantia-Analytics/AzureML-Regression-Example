## This file contains the code for the transformation of the raw bike rental
## data. it is intended to run in an Azure ML Execute R Script module. By changing
## some comments you can test the code in RStudio reading data from a .csv file. 

## The next two lines are used for testing in RStudio only.
## These lines should be commented out and the following 
## line should be uncommented when running in Azure ML.
#BikeShare <- read.csv("BikeSharing.csv", sep = ",", header = T, stringsAsFactors = F )
#BikeShare$dteday <- as.POSIXct(strptime(paste(BikeShare$dteday, " ", "00:00:00", sep = ""), "%Y-%m-%d %H:%M:%S"))
BikeShare <- maml.mapInputPort(1)

BikeShare <- BikeShare[, c(2, 5, 6, 7, 9, 10, 11, 13, 14, 15, 16, 17)] ## Select the columns we need

BikeShare[, 6:9] <- scale(BikeShare[, 6:9])  ## Normalize the numeric perdictors

## Take the log of response variables. First we must ensure there are no
## zero values. The difference between 0 and 1 is inconsequential. 
BikeShare[, 10:12] <- lapply(BikeShare[, 10:12], 
                             function(x){ifelse(x == 0, 1, x)})
BikeShare[, 10:12] <- lapply(BikeShare[, 10:12], function(x){log(x)})

# Create a new variable to indicate workday
BikeShare$isWorking <- ifelse(BikeShare$workingday & !BikeShare$holiday, 1, 0)  ## Create a new variable to indicate workday

## Add a column of the count of months which could help model trend.
## Next line is only needed running in Azure ML
Dteday <- strftime(BikeShare$dteday, format = "%Y-%m-%dT%H:%M:%S")
yearCount <- as.numeric(unlist(lapply(strsplit(Dteday, "-"), function(x){x[1]}))) - 2011 
BikeShare$monthCount <- 12 * yearCount + BikeShare$mnth

## Create an ordered factor for the day of the week starting with Monday.
## Note this factor is then converted to an "ordered" numerical value to be
## compatible with Azure ML table data types.
BikeShare$dayWeek <- as.factor(weekdays(BikeShare$dteday))
BikeShare$dayWeek <- as.numeric(ordered(BikeShare$dayWeek, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")))

## Add a variable with unique values for time of day for working and non-working days.
BikeShare$workTime <- ifelse(BikeShare$isWorking, BikeShare$hr, BikeShare$hr + 24) 

## Shift the order of the hour variable so that it is smoothly
## "humped over 24 hours.
BikeShare$xformHr <- ifelse(BikeShare$hr > 4, BikeShare$hr - 5, BikeShare$hr + 19)

## Output the transformed data frame.
maml.mapOutputPort('BikeShare')