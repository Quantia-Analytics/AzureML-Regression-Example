## This code computes a random forest model.
## This code is s intended to run in an Azure ML 
## Execute R Script module. By setting the Azure 
## variable to FALSE this code can be run in R
## or RStudio.
Azure <- FALSE

if(Azure){
  ## Source the zipped utility file
  source("src/utilities.R")
  ## Read in the dataset. 
  BikeShare2 <- maml.mapInputPort(1)  
  BikeShare2$dteday <- set.asPOSIXct2(BikeShare2)
} 

require(randomForest)
rf.bike <- randomForest(cnt ~ xformWorkHr + dteday +
                          temp + hum, 
                        data = BikeShare, ntree = 40, 
                        importance = TRUE, nodesize = 5)


outFrame <- serList(list(bike.model = rf.bike))

## Output the serialized model data frame.
if(Azure) maml.mapOutputPort('outFrame')
