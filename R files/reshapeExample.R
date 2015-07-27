## This file contains the code for reshaping a simple
## data set into simple case rows.
## This code is intended to run in an 
## Azure ML Execute R Script module. By changing
## the following vaiable to false the code will run
## in R or RStudio.
Azure <- FALSE

## If we are in Azure, source the utilities from the zip
## file. The next lines of code read in the dataset, either 
## in Azure ML or from a csv file for testing purposes.
if(Azure){
  Survey <- maml.mapInputPort(1)
  ## Install the tidyr package from the zip file
  install.packages("src/tidyr_0.2.0.zip", lib = ".", repos = NULL, verbose = TRUE)
  require(tidyr, lib.loc=".")
}else{
  Survey <- read.csv("Survey-Data.csv", sep = ",", 
                        header = T, stringsAsFactors = F )
  require(tidyr)
}


frame.out <- spread(Survey, Question, Response)

Survey2 <- gather(frame.out, Response, value, 2:6)

if(Azure) maml.mapOutputPort("frame.out")