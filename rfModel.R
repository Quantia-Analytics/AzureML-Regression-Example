## This code computes a random forest model.
## This code is s intended to run in an Azure ML Execute R 
## Script module. It can be tested in RStudio by now executing the Azure ML
## specific code.

## Source the zipped utility file
source("src/utilities.R")

## Read in the dataset. 
BikeShare <- maml.mapInputPort(1)

library(randomForest)
rf.bike <- randomForest(cnt ~ xformHr + temp + monthCount + hum + dayWeek + mnth + isWorking + workTime, 
                        data = BikeShare, ntree = 500, importance = TRUE, nodesize = 25)

importance(rf.bike)

outFrame <- serList(list(bike.model = rf.bike))

## Output the serialized model data frame.
maml.mapOutputPort('outFrame')