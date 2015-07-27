## This file contains the code for the simple filtering
## and ploting of the raw bike rental data. 
## This code is intended to run in an 
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
  BikeShare$dteday <- char.toPOSIXct(BikeShare)
  require(dplyr)
  BikeShare <- mutate(BikeShare, casual = NULL, 
                      registered = NULL, instant = NULL,
                      atemp = NULL)
}

PCA.out  <- prcomp(~ . - cnt - dteday,
                   data = BikeShare, scale = TRUE)
plot(PCA.out)

temp <- as.matrix(BikeShare[, rownames(PCA.out$rotation)]) %*%
                  PCA.out$rotation[, 1:4]
        
BikeShare <- cbind(BikeShare[, c("cnt", "dteday")],
                    temp)

if(Azure) maml.mapOutputPort("BikeShare")