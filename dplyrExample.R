Azure = FALSE

if(Azure){
  restaurants <- maml.mapInputPort(1)
  ratings <- maml.mapInputPort(2) 
}else{
  restaurants  <- read.csv("C:\\Users\\Steve\\Documents\\AzureML\\Data Sets\\Restaurant\\Restaurant_features.csv", 
                          sep = ",", header = T, stringsAsFactors = F )
  ratings <- read.csv("C:\\Users\\Steve\\Documents\\AzureML\\Data Sets\\Restaurant\\Restaurant_ratings.csv", 
                      sep = ",", header = T, stringsAsFactors = F)
}

restaurants <- restaurants[restaurants$franchise == 'f' &
                           restaurants$alcohol != 'No_Alcohol_Served', ]

require(dplyr)
out.frame <- as.data.frame( restaurants %>%
  inner_join(ratings, by = 'placeID') %>%
  select(name, rating) %>%
  group_by(name) %>%
  summarize(ave_Rating = mean(rating)) %>%
  arrange(desc(ave_Rating))) 

if(Azure) maml.mapOutputPort("out.frame")