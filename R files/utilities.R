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

serList <- function(serlist){
  ## Function to serialize list of R objects and 
  ## returns a dataframe. The argument is a list 
  ## of R objects. The function returns a serialized 
  ## list with two elements. The first element is 
  ## count of the elements in the input list.
  ## The second element, called payload, containts 
  ## the input list. If the serialization fails, 
  ## the first element will have a value of 0,
  ## and the payload will be NA.
  
  ## Messages to use in case an error is encountered.
  messages  <- c("Input to function serList is not list of length greater than 0",
                 "Elements of the input list to function serList are NULL or of length less than 1",
                 "The serialization has failed in function serList")
  
  ## Check the input list for obvious problems
  if(!is.list(serlist) | is.null(serlist) | 
       length(serlist) < 1) {
    warning(messages[2])
    return(data.frame(as.integer(serialize(
        list(numElements = 0, payload = NA), 
      connection = NULL))))}
  
  ## Find the number of objects in the input list.
  nObj  <-  length(serlist)
  
  ## Serialize the output list and return a data frame.
  ## The serialization and assignment are wrapped in 
  ## tryCatch in case anything goes wrong. 
  tryCatch(outframe <- data.frame(payload = as.integer(
        serialize(list(numElements = nObj, 
                   payload = serlist), 
          connection=NULL))),
      error = function(e){warning(messages[3])
        outframe <- data.frame(
          payload = as.integer(serialize(list(
           numElements = 0, payload = NA), 
           connection=NULL)))}
    )
  outframe
}


unserList <- function(inlist){
  ## Function unserializes a list of R objects
  ## which are stored in a column of a dataframe.
  ## The unserialized R objects are returned in a list.
  ## If the unserialize fails for any reason a value of
  ## NA is returned.
  
  ## Some messages to use in case of error. 
  messages <- c("The payload column is missing or not of the correct type",
                "Unserialization has failed in function unserList",
                "Function unserList has encountered an empty list")
  
  ## Check the input type.
  if(!is.integer(inlist$payload) | dim(inlist)[1] < 2 | 
       is.null(inlist$payload)){
    warning(messages[1]) 
    return(NA)
  }
  
  ## Unserialized the list. The unserialize and 
  ## assignment are wrapped in tryCatch in case something
  ##  goes wrong. 
  tryCatch(outList <- unserialize(as.raw(inlist$payload)),
           error = function(e){warning(messages[2]); return(NA)})
  
  ## Check if the list is empty, which indicates something went 
  ## wrong with the serialization provess.
  if(outList$numElements < 1 ) {warning(messages[3]); 
                                return(NA)}
  
  outList$payload
}
