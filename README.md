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
