# machine-learning-project

Data
---------
This project uses:
* training data available at: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv
* test data available at: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

<br>

Aim
----------
This project aims to predict the "classe" variable in the training set. To do so, I will:
* Process the test Data
* Split the Data Using Cross Validation
* Build a Prediction Model
* Evaluate the Model 

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
```

As such, I created a new data frame, new_data, where the columns containing missing values have been removed. As seen from the table function, we are left with 60 columns that have 0 NA values. 

```r
new_data <- data[ , colSums(is.na(data)) == 0]
table(sapply(new_data, function(x) {sum(is.na(x))}))
```
A look at the names of new_data show that the first 7 columns are not sensor readings. As such, these are removed.
```r
names(new_data)[1:10]
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
