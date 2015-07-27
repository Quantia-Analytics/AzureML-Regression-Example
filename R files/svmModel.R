## This code computes a support vector machine model.
## This code is s intended to run in an Azure ML Execute R 
## Script module. It can be tested in RStudio by now executing the Azure ML
## specific code.

## Source the zipped utility file
source("src/utilities.R")

## Read in the dataset. 
BikeShare <- maml.mapInputPort(1)

library(kernlab)
svm.bike <- ksvm(cnt ~ xformHr + hr + temp + monthCount + hum + workTime, 
                 data = BikeShare,
                 C = 1000,
                 cache = 1000,
                 type = "nu-svr")

outFrame <- serList(list(bike.model = svm.bike))

## Output the serialized model data frame.
maml.mapOutputPort('outFrame')