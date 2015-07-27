## This code will compute predictions from test data 
## for R models of various types. This code is 
## intended to run in an Azure ML Execute R 
## Script module. By changing the following variable
## you can run the code in R or RStudio for testing.
Azure <- FALSE

if(Azure){
  ## Sourcethe zipped utility file
  source("src/utilities.R")
  ## Read the data frame containing the serialized 
  ## model object.
  modelFrame  <- maml.mapInputPort(1)
  ## Read in the dataset. 
  BikeShare <- maml.mapInputPort(2)
  BikeShare$dteday <- set.asPOSIXct2(BikeShare)
} else {
  ## comment out the following line if running in Azure ML.
  modelFrame <- outFrame
}


## Extract the model from the serialized input and assign 
## to a convenient name. 
modelList <- unserList(modelFrame)
bike.model <- modelList$bike.model

## Output a data frame with actual and values predicted 
## by the model.
require(gam)
require(randomForest)
require(kernlab)
require(nnet)
outFrame <- data.frame( actual = BikeShare$cnt,
                       predicted = 
                         predict(bike.model, 
                                 newdata = BikeShare))

## The following line should be executed only when running in
## Azure ML Studio to output the serialized model. 
if(Azure) maml.mapOutputPort('outFrame') 