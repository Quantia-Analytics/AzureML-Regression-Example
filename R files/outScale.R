## This scales the output of the model prediction to actual values
## from the log scale used in the models.
## This code is s intended to run in an Azure ML Execute R 
## Script module.

## Read in the dataset 
inFrame <- maml.mapInputPort(1)

## Since the model was computed using the log of bike demand
## transform the results to actual counts.
inFrame[, 9] <- exp(inFrame[, 9])

## Select the columns and apply names for output.
outFrame <- inFrame[, c(1, 2, 3, 9)]
colnames(outFrame) <- c('Date', "Month", "Hour", "BikeDemand")

## Output the transformed data frame.
maml.mapOutputPort('outFrame')