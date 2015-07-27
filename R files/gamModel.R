## This code computes a gam model.
## This code is s intended to run in an Azure ML Execute R 
## Script module. It can be tested in RStudio by now executing the Azure ML
## specific code.

## Source the zipped utility file
source("src/utilities.R")

## Read in the dataset. 
BikeShare <- maml.mapInputPort(1)

library(gam)
gam.bike <- gam(cnt ~ s(hr) + s(mnth) + s(monthCount) + s(workTime), 
                data = BikeShare)

outFrame <- serList(list(bike.model = gam.bike))

## Output the serialized model data frame.
maml.mapOutputPort('outFrame')