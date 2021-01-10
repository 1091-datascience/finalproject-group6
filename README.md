# Analytics Vidhya - Big Mart Sales Prediction Problem

### Group 6
* 廖宇凡 108753014 
* 紀秉杰 109753128 
* 黃渝庭 109753102 
* 陳子賢 107703048 
* 李元亨 107703004 

### Goal
Predict the Big Mart Sales Prediction Problem.
### Demo 
You should provide an example commend to reproduce your result
``` text
Rscript code.r
```
* any on-line visualization

### data

* Source
  * [Analytics Vidhya - Big Mart Sales Prediction Problem](https://datahack.analyticsvidhya.com/contest/practice-problem-big-mart-sales-iii/)
* Input format
  * One file formatted with `.csv`
  * Features of dataset:
    * Item_Identifier	: Unique product ID
    * Item_Weight	Weight of product
    * Item_Fat_Content	Whether the product is low fat or not
    * Item_Visibility	The % of total display area of all products in a * store allocated to the particular product
    * Item_Type	The category to which the product belongs
    * Item_MRP	Maximum Retail Price (list price) of the product
    * Outlet_Identifier	Unique store ID
    * Outlet_Establishment_Year	The year in which store was established
    * Outlet_Size	The size of the store in terms of ground area covered
    * Outlet_Location_Type	The type of city in which the store is located
    * Outlet_Type	Whether the outlet is just a grocery store or some sort of supermarket
    Item_Outlet_Sales	Sales of the product in the particular store. This is the outcome variable to be predicted.

    | Variabel | Description | 
    | :---: | :---: |
    | Item_Identifier | 301 |
    | Item_Weight | 301 |
    | Item_Fat_Content | 301 |
    | Item_Visibility | 301 |
    | Item_Weight | 301 |
    | Item_Weight | 301 |
    | Item_Weight | 301 |
    | Item_Weight | 301 |
    | Item_Weight | 301 |
    | Item_Weight | 301 |
    | Item_Weight | 301 |

* Any preprocessing?
  * Handle missing data
    * total_bedrooms has 207 missing value.
      ![](docs/images/total_bedrooms_missing.png)
  * Scale value
    * population_per_household
    * bedrooms_per_room 
    * rooms_per_household
    ![](docs/images/correlation_matrix.png)
  
### code

* Which method do you use?
  * Linear regression / Lasso / Ridge / Elastic net 
  * SVM / RF / GBT / Stacking
* What is a null model for comparison?
  * Linear regression with no regressor.
* How do your perform evaluation? ie. Cross-validation, or extra separated data
  * k-fold

### results

* Which metric do you use ?
  * MAPE
* Is your improvement significant?
  * Yes ! We improve MAPE from 1.84 to 1.76
* What is the challenge part of your project?
  * Tuning

## Reference
* Code/implementation which you include/reference (__You should indicate in your presentation if you use code for others. Otherwise, cheating will result in 0 score for final project.__)
* Packages you use
  * mice, ggplot2, dplyr, gapminder, scales, hrbrthemes, viridis, ggcorrplot, rBayesianOptimization, randomForest, rpart, tidyverse, caret, pROC, regclass, adabag, alr4, DMwR, nnet,  
* Related publications
  *  https://jmyao17.github.io/Kaggle/California_Housing_Prices.html
  *  https://rpubs.com/ablythe/520912
  *  [In a random forest, is larger %IncMSE better or worse? (2016).](https://bit.ly/2BeuUAR
  *  Lander, J. P. (2017). R for Everyone: Advanced Analytics and Graphics, 2nd Edition.
  *  Ozdemir, S., Susarla, D. (2018). Feature Engineering Made Easy.
  *  Ariga, M., Nakayama, S., Nishibayashi, T. (2018). Machine Learning at Work



