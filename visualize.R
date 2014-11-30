## This code will create a series of data visualizations to explore the bike 
## rental dataset. This code is s intended to run in an Azure ML Execute R 
## Script module. By changing some comments you can test the code in RStudio.

## Source the zipped utility file
source("src/utilities.R")

## Read in the dataset. 
BikeShare <- maml.mapInputPort(1)

## Extract the date in character format 
BikeShare$dteday <- get.date(BikeShare$dteday)

## Look at the correlation between the predictors and 
## between predictors and quality. Use a linear time series regression
## to detrend the demand.
Time <- POSIX.date(BikeShare$dteday, BikeShare$hr)
BikeShare$count <- BikeShare$cnt - fitted(lm(BikeShare$cnt ~ Time, data = BikeShare))
cor.BikeShare.all <- cor(BikeShare[, c("mnth", "hr", 
                                       "weathersit", "temp",
                                       "hum", "windspeed",
                                       "isWorking", "monthCount", 
                                       "dayWeek", "count")])

diag(cor.BikeShare.all) <- 0.0 
cor.BikeShare.all
library(lattice)
levelplot(cor.BikeShare.all, main ="Correlation matrix for all bike users",
          scales=list(x=list(rot=90), cex=1.0))

## Make time series plots for certain hours of the day
times <- c(7, 9, 12, 15, 18, 20, 22)
lapply(times, function(x){
       plot(Time[BikeShare$hr == x], BikeShare$cnt[BikeShare$hr == x], 
            type = "l", xlab = "Date", ylab = "Number of bikes used",
            main = paste("Bike demand at ",as.character(x), ":00", spe ="")) } )

## Convert dayWeek back to an ordered factor so the plot is in
## time order.
BikeShare$dayWeek <- fact.conv(BikeShare$dayWeek)

## This code gives a first look at the predictor values vs the demand for bikes.
library(ggplot2)
labels <- list("Box plots of hourly bike demand",
            "Box plots of monthly bike demand",
            "Box plots of bike demand by weather factor",
            "Box plots of bike demand by workday vs. holiday",
            "Box plots of bike demand by day of the week")
xAxis <- list("hr", "mnth", "weathersit", "isWorking", "dayWeek")
Map(function(X, label){ ggplot(BikeShare, 
                               aes_string(x = X, y = "cnt", group = X)) + 
                           geom_boxplot( ) + ggtitle(label) +
                           theme(text = element_text(size=18))},
    xAxis, labels)

## Look at the relationship between predictors and bike demand
labels <- c("Bike demand vs temperature",
            "Bike demand vs humidity",
            "Bike demand vs windspeed",
            "Bike demand vs hr",
            "Bike demand vs xformHr")
xAxis <- c("temp", "hum", "windspeed", "hr", "xformHr")
Map(function(X, label){ggplot(BikeShare, aes_string(x = X, y = "cnt")) + 
                         geom_point(aes_string(colour = "cnt"), alpha = 0.1) + scale_colour_gradient(low = "green", high = "blue") + 
                         geom_smooth(method = "loess") + 
                         ggtitle(label) +
                         theme(text = element_text(size=20))},
    xAxis, labels)

## Explore the interaction between time of day
## and working or non-working days.
labels <- list("Box plots of bike demand at 0900 for working and non-working days",
               "Box plots of bike demand at 1800 for working and non-working days")
Times <- list(8, 17)
Map(function(time, label){ ggplot(BikeShare[BikeShare$hr == time, ], 
                                  aes(x = isWorking, y = cnt, group = isWorking)) + 
                             geom_boxplot( ) + ggtitle(label) +
                             theme(text = element_text(size=18))},
    Times, labels)

