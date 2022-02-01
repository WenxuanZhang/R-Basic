#Library
library(dplyr)
#1. Special Cases: 

test<-data.frame(product = c('Apple','Bread','Citrus'),price = c(1.99,2.49,3.49), 
              order_units = c(10,15,NA), stringsAsFactors = FALSE)
test<- test %>% mutate(order_rev  = order_units * price)

#enter NC
if(test$order_units[3]>0){
  print(paste('some one ordered ',test$order_units[3,],'Units',test$order_units[3,] ))
}
#error message:
#Error in if (test$order_units[3] > 0) { : 
#    missing value where TRUE/FALSE needed

#Similar info will happen when enter NULL

if(NULL){
  print('hello world')
}

# Error in if (NULL) { : argument is of length zero

#2. Input type does not match 
sum(1,2,3)
sum('a','b')


#3. Syntax： you did not use the function the right way (example: Shiny Module)

#4. Namespace conflicting: dplyr and plyr impact on group
library(dplyr)
test1 <- test %>% group_by(product) %>% summarise(order_units = sum(order_units))
print(test1)
library(plyr)
test1 <- test %>% group_by(product) %>% summarise(order_units = sum(order_units))
print(test1)
detach("package:plyr")
library(dplyr)
test1 <- test %>% group_by(product) %>% summarise(order_units = sum(order_units))
print(test1)

