
library(lattice); library(ggplot2); library(caret);library(randomForest)

data <- read.csv("~/Documents/machine-learning-project/pml-training.csv",
                 na.strings = c("#DIV/0!","NA", ""))
table(sapply(data, function(x) {sum(is.na(x))}))

new_data <- data[ , colSums(is.na(data)) == 0]
table(sapply(new_data, function(x) {sum(is.na(x))}))

new_data <- new_data[,8:length(new_data)]

set.seed(1)

inTrain <- createDataPartition(y=new_data$classe, p=0.7, list=FALSE)
training <- new_data[inTrain,]
testing <- new_data[-inTrain,]

set.seed(2)

start <- proc.time()
rfFit <- randomForest(formula = classe ~ ., data = training, ntree = 500)
time <- proc.time() - start

rf_prediction <- predict(rfFit,newdata = testing)
confusionMatrix(rf_prediction, testing$classe)

#Confusion Matrix and Statistics

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


gbmFit <- train(classe ~ ., method="gbm", data=training, verbose=FALSE)
gbm_prediction <- predict(gbmFit,newdata = testing)
confusionMatrix(gbm_prediction, testing$classe)


# rfFit.2 = train(classe~., method="rf", data=training, verbose = FALSE)
# time <- proc.time() - start
# time
#user   system  elapsed 
#4437.967   57.750 4631.342 

#Accuracy : 0.9951 
