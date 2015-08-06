## This code will create a series of data visualizations
## to explore the bike rental dataset. This code is 
## intended to run in an Azure ML Execute R 
## Script module. By changing the following variable
## you can run the code in R or RStudio for testing.
Azure <- FALSE

if(Azure){
  ## Source the zipped utility file
  source("src/utilities.R")
  ## Read in the dataset. 
  BikeShare <- maml.mapInputPort(1)
  BikeShare$dteday <- set.asPOSIXct2(BikeShare)
}


## Look at the correlation between the predictors and 
## between predictors and quality. Use a linear 
## time series regression to detrend the demand.
Time <- BikeShare$dteday
BikeShare$count <- BikeShare$cnt - fitted(
  lm(BikeShare$cnt ~ Time, data = BikeShare))
cor.BikeShare.all <- cor(BikeShare[, c("mnth", 
                                       "hr", 
                                       "weathersit", 
                                       "temp",
                                       "hum", 
                                       "windspeed",
                                       "isWorking", 
                                       "monthCount", 
                                       "dayWeek", 
                                       "count")])

diag(cor.BikeShare.all) <- 0.0 
cor.BikeShare.all
require(lattice)
plot( levelplot(cor.BikeShare.all, 
        main ="Correlation matrix for all bike users",
        scales=list(x=list(rot=90), cex=1.0)) )

## Make time series plots for certain hours of the day
require(ggplot2)
times <- c(7, 9, 12, 15, 18, 20, 22)
# BikeShare$Time <- Time
lapply(times, function(times){
  ggplot(BikeShare[BikeShare$hr == times, ], 
         aes(x = dteday, y = cnt)) +
    geom_line() +
    ylab("Log number of bikes") +
    labs(title = paste("Bike demand at ",
                       as.character(times), ":00", spe ="")) +
    theme(text = element_text(size=20))
    })

## Convert dayWeek back to an ordered factor so the plot is in
## time order.
BikeShare$dayWeek <- fact.conv(BikeShare$dayWeek)

## This code gives a first look at the predictor values vs the demand for bikes.
labels <- list("Box plots of hourly bike demand",
            "Box plots of monthly bike demand",
            "Box plots of bike demand by weather factor",
            "Box plots of bike demand by workday vs. holiday",
            "Box plots of bike demand by day of the week")
xAxis <- list("hr", "mnth", "weathersit", 
              "isWorking", "dayWeek")
Map(function(X, label){ 
      ggplot(BikeShare, aes_string(x = X, 
                                   y = "cnt", 
                                  group = X)) + 
      geom_boxplot( ) + ggtitle(label) +
                           theme(text = 
                                   element_text(size=18)) },
    xAxis, labels)

## Look at the relationship between predictors and bike demand
labels <- c("Bike demand vs temperature",
            "Bike demand vs humidity",
            "Bike demand vs windspeed",
            "Bike demand vs hr",
            "Bike demand vs xformHr",
            "Bike demand vs xformWorkHr")
xAxis <- c("temp", "hum", "windspeed", "hr", 
           "xformHr", "xformWorkHr")
Map(function(X, label){ 
      ggplot(BikeShare, aes_string(x = X, y = "cnt")) + 
      geom_point(aes_string(colour = "cnt"), alpha = 0.1) + 
      scale_colour_gradient(low = "green", high = "blue") + 
      geom_smooth(method = "loess") + 
      ggtitle(label) +
      theme(text = element_text(size=20)) },
    xAxis, labels)


## Explore the interaction between time of day
## and working or non-working days.
labels <- list("Box plots of bike demand at 0900 for \n working and non-working days",
               "Box plots of bike demand at 1800 for \n working and non-working days")
Times <- list(8, 17)
Map(function(time, label){ 
      ggplot(BikeShare[BikeShare$hr == time, ], 
         aes(x = isWorking, y = cnt, group = isWorking)) + 
      geom_boxplot( ) + ggtitle(label) +
      theme(text = element_text(size=18)) },
    Times, labels)

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
