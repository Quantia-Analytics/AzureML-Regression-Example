## This code computes a neural network regression model.
## This code is s intended to run in an Azure ML Execute R 
## Script module. It can be tested in RStudio by now executing the Azure ML
## specific code.

## Source the zipped utility file
source("src/utilities.R")

## Read in the dataset. 
BikeShare <- maml.mapInputPort(1)

library(nnet)
nn.bike <- avNNet(cnt ~ xformHr + hr + orderHr + mnth + weathersit + monthCount + hum, 
                data = BikeShare,
                linout = TRUE,
                size = 5,
                decay = 0.01,
                maxit = 500,
                maxNWts = 5 * (7 + 5 + 1))

outFrame <- serList(list(bike.model = nn.bike))

## Output the serialized model data frame.
maml.mapOutputPort('outFrame')