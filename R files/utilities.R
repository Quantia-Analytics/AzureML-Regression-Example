## This code contains some utility functions used in 
## several Execute R Script modules. This file should 
## be zipped and uploaded as a dataset into Azure ML
## Studio. Each Execute R Script model which uses 
## these utilities imports them using the R source() 
## function. 

set.asPOSIXct <- function(inFrame) { 
  dteday <- as.POSIXct(
    as.integer(inFrame$dteday), 
    origin = "1970-01-01")
  
  as.POSIXct(strptime(
    paste(as.character(dteday), 
          " ", 
          as.character(inFrame$hr),
          ":00:00", 
          sep = ""), 
    "%Y-%m-%d %H:%M:%S"))
}

char.toPOSIXct <-   function(inFrame) {
  as.POSIXct(strptime(
    paste(inFrame$dteday, " ", 
          as.character(inFrame$hr),
          ":00:00", 
          sep = ""), 
    "%Y-%m-%d %H:%M:%S")) }


set.asPOSIXct2 <- function(inFrame) { 
  dteday <- as.POSIXct(
    as.integer(inFrame$dteday), 
    origin = "1970-01-01")
}


fact.conv <- function(inVec){
  ## Function gives the day variable meaningful 
  ## level names.
  outVec <- as.factor(inVec)
  levels(outVec) <- c("Monday", "Tuesday", "Wednesday", 
                      "Thursday", "Friday", "Saturday", 
                      "Sunday")
  outVec
}

get.date <- function(Date){
  ## Funciton returns the data as a character 
  ## string from a POSIXct datatime object. 
  temp <- strftime(Date, format = "%Y-%m-%d %H:%M:%S")
  substr(unlist(temp), 1, 10)
}


POSIX.date <- function(Date,Hour){
  ## Function returns POSIXct time series object 
  ## from date and hour arguments.
  as.POSIXct(strptime(paste(Date, " ", as.character(Hour), 
                            ":00:00", sep = ""), 
                        "%Y-%m-%d %H:%M:%S"))
}

var.log <- function(inFrame, col){
  outVec <- ifelse(inFrame[, col] < 0.1, 1, inFrame[, col])
  log(outVec)
}

month.count <- function(inFrame){
  Dteday <- strftime(inFrame$dteday, 
                     format = "%Y-%m-%dT%H:%M:%S")
  yearCount <- as.numeric(unlist(lapply(strsplit(
    Dteday, "-"), 
    function(x){x[1]}))) - 2011 
  inFrame$monthCount <- 12 * yearCount + inFrame$mnth
  inFrame
}

