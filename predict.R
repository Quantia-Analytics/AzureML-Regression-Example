## This code will compute predictions from test data 
## for R models of various types. This code is 
## intended to run in an Azure ML Execute R Script module. 
## By changing some comments you can test the code 
## in RStudio.

## Source the zipped utility file
source("src/utilities.R")

## Get the data frame with the model from port 1 
## and the data set from port 2. These two lines 
## will only work in Azure ML. 
modelFrame  <- maml.mapInputPort(1)
BikeShare <- maml.mapInputPort(2)

## comment out the following line if running in Azure ML.
#modelFrame <- outFrame

## Extract the model from the serialized input and assign 
## to a convenient name. 
modelList <- unserList(modelFrame)
bike.model <- modelList$bike.model

## Output a data frame with actual and values predicted 
## by the model.
library(gam)
library(randomForest)
library(kernlab)
library(nnet)
outFrame <- data.frame( actual = BikeShare$cnt,
                       predicted = 
                         predict(bike.model, 
                                 newdata = BikeShare))

## The following line should be executed only when running in
## Azure ML Studio to output the serialized model. 
maml.mapOutputPort('outFrame') 