# machine-learning-project

Data
---------
This project uses data from accelerometers ont he belt, forearm, arm, and dumbell of 6 particpants. In particular, 
* training data available at: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv
* test data available at: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

<br>

Aim
----------
The 6 participants of the data above were asked to perform barbell lifts correctly and incorrectly in 5 different ways. This project aims to predict, based on accelerometer information, their manner of excercise out of these 5 ways. This is the "classe" variable in the training set. To do so, I will:
* Process the test Data
* Split the Data Using Cross Validation
* Build a Prediction Model
* Evaluate the Model 
* Predict on 20 Test Cases

<br>

Data Processing
--------------
First, as shown below, the data is imported into the data variable.

```r
library(lattice); library(ggplot2); library(caret);library(randomForest)  #load packages
data <- read.csv("~/Documents/machine-learning-project/pml-training.csv", #import data
                 na.strings = c("#DIV/0!","NA", "")) #account for s
```

Next, a look at the missing values shows that there are a large number of columns containing a majority of missing values. 
```r
table(sapply(data, function(x) {sum(is.na(x))}))
# Number of NAs  0 19216 19217 19218 19220 19221 19225 19226 19227 19248 19293 19294 19296 19299 19300 19301 19622 
# Freq          60    67     1     1     1     4     1     4     2     2     1     1     2     1     4     2     6 

```

As such, I decided to clean the data by removing columns with mostly missing values. The resulting new_data only has columns that contain no missing values. As seen from the table function, we are left with 60 columns that have 0 NA values. 

```r
new_data <- data[ , colSums(is.na(data)) == 0]
table(sapply(new_data, function(x) {sum(is.na(x))}))
#NA Values 0 
#Freq     60 
```
A look at the names of new_data show that the first 7 columns are not sensor readings. These columns won't be useful for predicting classe, so I removed them.

```r
names(new_data)[1:10]
 #[1] "X"                    "user_name"            "raw_timestamp_part_1" "raw_timestamp_part_2" "cvtd_timestamp"      
 #[6] "new_window"           "num_window"           "roll_belt"            "pitch_belt"           "yaw_belt"   

new_data <- new_data[,8:length(new_data)]
```
<br>

Splitting Data
--------------
Using the createDataPartition function of the caret package, I split up new_data into a training set to train the model on, and a testing set to run predictions on (to test the accuracy of the model).

```r
set.seed(1)

inTrain <- createDataPartition(y=new_data$classe, p=0.7, list=FALSE)
training <- new_data[inTrain,]
testing <- new_data[-inTrain,]
```

Building a Prediction Model
--------------------------
Now, I will create a model to predict the classe variable. I chose to build a random forest model using the randomForest package, as it produced accurate results in a relatively short span of time. 
In addition, I took proc.time() before and after the prediction was done, and subtracted this to find the total elapsed time.

```r
set.seed(2)

start <- proc.time()
rfFit <- randomForest(formula = classe ~ ., data = training, ntree = 500)
time <- proc.time() - start

```

Evaluating the Model
--------------------
Looking at the variable 'time', we find that the elapsed time was 45.200,which is relatively short.

```r
time
   user  system elapsed 
 42.806   0.772  45.200 
```

Next, we evaluate how accurate the model is by using it to predict on the testing set. A summary of results is obtained using the confusionMatrix function. The output is shown below. From this, we get an accuracy of 99.68%. In other words, we can estimate an **out of sample error of 0.32%**. The low error is promising, and suggests that the random forest model was effective. For more accurate results, ntree could be increased, though this would lead to a trade-off in runtime. 

```r
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
```

Though it is not shown here, I ran the train function of the caret package using method = 'rf' for comparison. This produced the results shown below. As you can see, this method produces a lower accuracy (of 99.51%) and much longer runtime (with an elapsed time of 4631.342). As such, the model I chose was both faster and more accurate. 

```r
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


time #find the runtime
#    user   system  elapsed 
#4437.967   57.750 4631.342 
```

Predicting on 20 Test Cases
--------------------------
Finally, to further evaluate my model, I tested it on a separate test set with 20 cases I first imported the test set into pml.test, then ran the predict function using my model. The resulting prediction was correct 20/20 times, supporting the accuracy of the model.

```r
pml.test <- read.csv("~/Documents/machine-learning-project/pml-testing.csv",
            na.strings = c("#DIV/0!","NA", ""))
pml.predict <- predict(rfFit, pml.test)
```
