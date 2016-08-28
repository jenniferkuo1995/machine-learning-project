
#import packages
library(lattice); library(ggplot2); library(caret);library(randomForest)

#read in the training data
data <- read.csv("~/Documents/machine-learning-project/pml-training.csv",
                 na.strings = c("#DIV/0!","NA", ""))

#pre-processing data

table(sapply(data, function(x) {sum(is.na(x))})) # look at how many NA values there are
new_data <- data[ , colSums(is.na(data)) == 0]   # remove columns containing a majority of NA values
table(sapply(new_data, function(x) {sum(is.na(x))})) #results show that there are now 60 columns with 0 NA values.

#remove the first 7 columns, which are not sensor readings
new_data <- new_data[,8:length(new_data)]

#split the  data into 70/30 training set and test set.
set.seed(1)
inTrain <- createDataPartition(y=new_data$classe, p=0.7, list=FALSE)
training <- new_data[inTrain,]
testing <- new_data[-inTrain,]

#run the random forest prediction algorithm
set.seed(2)
start <- proc.time() #record start time
rfFit <- randomForest(formula = classe ~ ., data = training, ntree = 500)
time <- proc.time() - start #find the time elapsed, to evaluate how long the model takes to build.

#evaluate the accuracy of the model by running it on the training set.
rf_prediction <- predict(rfFit,newdata = testing)
confusionMatrix(rf_prediction, testing$classe) #find out how accurate the prediction was

# Results of Confusion Matrix
#Reference
#Prediction    A    B    C    D    E
#          A 1672    2    0    0    0
#          B    1 1137    7    0    0
#          C    0    0 1018    4    0
#          D    0    0    1  959    2
#          E    1    0    0    1 1080

#Overall Statistics

#Accuracy : 0.9968         
#95% CI : (0.995, 0.9981)
#No Information Rate : 0.2845         
#P-Value [Acc > NIR] : < 2.2e-16      

#compared my first model against the random forest model from the caret package. 
#The results show that my first model was more accurate.
start <- proc.time()
rfFit.2 = train(classe~., method="rf", data=training, verbose = FALSE)
time <- proc.time() - start

# Accuracy : 0.9951          
#                 95% CI : (0.9929, 0.9967)
#    No Information Rate : 0.2845          
#    P-Value [Acc > NIR] : < 2.2e-16       
#                                          
#                  Kappa : 0.9938          
# Mcnemar's Test P-Value : NA    


#import the last test set, with 20 test cases, and run my first model on it. 
#Results were found to be correct 20/20 times.
pml.test <- read.csv("~/Documents/machine-learning-project/pml-testing.csv",
                     na.strings = c("#DIV/0!","NA", ""))
pml.predict <- predict(rfFit, pml.test)
