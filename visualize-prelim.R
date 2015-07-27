## This code will create a series of data visualizations
## to explore the bike rental dataset. This code is 
## intended to run in an Azure ML Execute R 
## Script module. By changing the following variable
## you can run the code in R or RStudio for testing.
Azure <- FALSE

if(Azure){
  ## Sourcethe zipped utility file
  source("src/utilities.R")
  ## Read in the dataset. 
  BikeShare <- maml.mapInputPort(1)
  BikeShare$dteday <- set.asPOSIXct2(BikeShare)
}


## Look at the correlation between the predictors and 
## between predictors and quality. Use a linear 
## time series regression to detrend the demand.
BikeShare$count <- BikeShare$cnt - predict(
  lm(cnt ~ dteday, data = BikeShare), newdata = BikeShare)

cols <- c("mnth", "hr", "holiday", "workingday",
           "weathersit", "temp", "hum", "windspeed",
           "isWorking", "monthCount", "dayWeek", 
           "workTime", "xformHr", "count")
methods <- c("pearson", "spearman") #, "kendal")

cors <- lapply( methods, function(method) 
  (cor(BikeShare[, cols], method = method)))

require(lattice)
plot.cors <- function(x, labs){
  diag(x) <- 0.0 
  plot( levelplot(x, 
                  main = paste("Correlation plot for", labs, "method"),
                  scales=list(x=list(rot=90), cex=1.0)) )
  }

Map(plot.cors, cors, methods)

## Make time series plots for certain hours of 
## working and non-working days
times <- c(7, 7+24,9, 9+24, 12, 12+24, 15, 15+24, 18, 18+24, 20, 20+24, 22, 22+24) 

tms.plot <- function(times){
  ggplot(BikeShare[BikeShare$workTime == times, ], 
         aes(x = dteday, y = cnt)) +
    geom_line() +
    ylab("Number of bikes") +
    labs(title = paste("Bike demand at ",
                       as.character(times), ":00", sep ="")) +
    theme(text = element_text(size=20))
}
require(ggplot2)
lapply(times, tms.plot)

## Convert dayWeek back to an ordered factor so the plot is in
## time order.
BikeShare$dayWeek <- fact.conv(BikeShare$dayWeek)

## This code gives a first look at the predictor values vs the demand for bikes.
labels <- list("Box plots of hourly bike demand",
            "Box plots of transformed hourly bike demand",
            "Box plots of demand by workTime",
            "Box plots of demand by xformWorkHr",
            "Box plots of monthly bike demand",
            "Box plots of bike demand by weather factor",
            "Box plots of bike demand by working day",
            "Box plots of bike demand by day of the week")
xAxis <- list("hr", "xformHr", "workTime", "xformWorkHr", 
              "mnth", "weathersit", "isWorking", "dayWeek")

plot.boxes  <- function(X, label){ 
  ggplot(BikeShare, aes_string(x = X, 
                               y = "cnt", 
                               group = X)) + 
    geom_boxplot( ) + ggtitle(label) +
    theme(text = element_text(size=18)) }

Map(plot.boxes, xAxis, labels)

## Look at the relationship between predictors and bike demand
labels <- c("Bike demand vs temperature",
            "Bike demand vs humidity",
            "Bike demand vs windspeed",
            "Bike demand vs hr",
            "Bike demand vs xformHr",
            "Bike demand vs xformWorkHr")
xAxis <- c("temp", "hum", "windspeed", "hr", "xformHr", "xformWorkHr")

plot.scatter <- function(X, label){ 
  ggplot(BikeShare, aes_string(x = X, y = "cnt")) + 
    geom_point(aes_string(colour = "cnt"), alpha = 0.1) + 
    scale_colour_gradient(low = "green", high = "blue") + 
    geom_smooth(method = "loess") + 
    ggtitle(label) +
    theme(text = element_text(size=20)) }

Map(plot.scatter, xAxis, labels)


## Explore the interaction between time of day
## and working or non-working days.
labels <- list("Box plots of bike demand at 0900 for \n working and non-working days",
               "Box plots of bike demand at 1800 for \n working and non-working days")
Times <- list(8, 17)

plot.box2 <- function(time, label){ 
  ggplot(BikeShare[BikeShare$hr == time, ], 
         aes(x = isWorking, y = cnt, group = isWorking)) + 
    geom_boxplot( ) + ggtitle(label) +
    theme(text = element_text(size=18)) }

Map(plot.box2, Times, labels)

