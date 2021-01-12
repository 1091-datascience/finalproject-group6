# Analytics Vidhya - Big Mart Sales Prediction Problem

### Group 6
* 廖宇凡 108753014 
* 紀秉杰 109753128 
* 黃渝庭 109753102 
* 陳子賢 107703048 
* 李元亨 107703004 

### Main Code (code.r) is moved from the master branch, please check the contributors from there, Thanks! 

### Goal
Predict the Big Mart Sales Prediction Problem.
### Demo 
You should provide an example commend to reproduce your result
``` text
Rscript code.r
```
Running `code.r` is going to output 5 `.csv` files, including
 1. `k_fold.csv`
 2. `Sub_v1_Tree.csv`
 3. `Sub_v1_RF.csv`
 4. `Sub_v1_LM.csv`
 5. `Sub_v1_XG.csv`

* any on-line visualization

### data

* Source
  * [Analytics Vidhya - Big Mart Sales Prediction Problem](https://datahack.analyticsvidhya.com/contest/practice-problem-big-mart-sales-iii/)
* About the data

    The data scientists at BigMart have collected 2013 sales data for 1559 products across 10 stores in different cities. Also, certain attributes of each product and store have been defined. The aim is to build a predictive model and predict the sales of each product at a particular outlet.

    Using this model, BigMart will try to understand the properties of products and outlets which play a key role in increasing sales.
* Input format
  * One file formatted with `.csv`
  * We have train (8523) and test (5681) data set.
  * Features of dataset:

    | Variabel | Description | 
    | :--- | :--- |
    | Item_Identifier | Unique product ID|
    | Item_Weight | Weight of product |
    | Item_Fat_Content | Whether the product is low fat or not |
    | Item_Visibility | The % of total display area of all products in a store allocated to the particular product |
    | Item_Type| The category to which the product belongs	|
    | Item_MRP	| Maximum Retail Price (list price) of the product|
    | Outlet_Identifier	| Unique store ID|
    | Outlet_Establishment_Year	| The year in which store was established|
    | Outlet_Size	| The size of the store in terms of ground area covered|
    | Outlet_Location_Type | The type of city in which the store is located|
    | Outlet_Type	| Whether the outlet is just a grocery store or some sort of supermarket|
    | Item_Outlet_Sales	| Sales of the product in the particular store. This is the outcome variable to be predicted. |


* Any preprocessing?
  * Handle missing data
    * Item_Weight with NA value
    * Item_Visibility with 0 value
    * Outlet_Size with “” (Null String)
  * New feature
    * Item_Volume
  * One hot encoding
  
### code

* Which method do you use?
  * Decision Tree
  * Random Forest ✓ ( The Best )
  * LM
  * XGBoost

* What is a null model for comparison?
<!--- TODO -->
* How do your perform evaluation? ie. Cross-validation, or extra separated data
  * k-fold Cross-validation

### results

* Is your improvement significant?
  * competition ranking 26/40204
<!--- TODO -->
* What is the challenge part of your project?
<!--- TODO -->

## Reference
* Code/implementation which you include/reference (__You should indicate in your presentation if you use code for others. Otherwise, cheating will result in 0 score for final project.__)
    * https://datahack.analyticsvidhya.com/contest/practice-problem-big-mart-sales-iii/
    * https://www.kaggle.com/usamakhan8199/big-mart-prediction-top-100-with-optimisation 
    * https://www.kaggle.com/bgsumanth/plots-in-r
    * https://rpubs.com/prateekjoshi565/381886?fbclid=IwAR3G67crQULEmecWedgaIysWx4OuA9DzWdY8S2Km96xv5wf7IW2gN7z2Z2Q
    * https://github.com/Param-Trivedi/Big-Mart-Sales-Data-Prediction

* Packages you use
```R
library(randomForest)
library(onehot)
library(tree)
library(rpart)
library(h2o)
library(xgboost)
library(vtreat)

# To import data in datafram
library(data.table)
# To make used of pipelining process and cleaning of data and descriptive analysis of data
library(dplyr)
# To visualize the data
library(ggplot2)
# To make a correlation plot
library(corrplot)
# To tune the model, and for feature selection
library(caret)
# To clean the data
library(tidyverse)
# To create a correlation heatmap
library(cowplot)
# To determine metrics of model
library(Metrics)
```
* Related publications
 

