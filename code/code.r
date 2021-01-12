library(caret)
library(onehot)
library(Metrics)
library(cowplot)
library(vtreat)
library(dplyr)

library(tree)
library(rpart)
library(h2o)
library(randomForest)
library(xgboost)

# Read text file
Train_Base = read.table("../data/Train.csv",header = TRUE , sep = ",")
Test_Base  = read.table("../data/Test.csv",header = TRUE , sep = ",")
Sub_Base = read.table("../data/sample_submission.csv",header = TRUE , sep = ",")

###################### Train #############################
## Replace Missing values in Item_Weight in other data
colSums(is.na(Train_Base))

Test_Base <- cbind(Test_Base, c(rep(0, times=5681)))
colnames(Test_Base)[12] <- 'Item_Outlet_Sales'
combined <- rbind(Train_Base, Test_Base)

combined[is.na(combined)] <- 0
identifier <- unique(combined$Item_Identifier)
for (id in identifier){
  weight <- max(combined[combined$Item_Identifier==id,"Item_Weight"])
  combined[combined$Item_Identifier==id,"Item_Weight"] <- weight
}

Train_Base$Item_Weight <- combined$Item_Weight[1:8523]

## REplace 0 in Item_Visibility by Mean
Train_Base$Item_Visibility[Train_Base$Item_Visibility == 0]<- mean(Train_Base$Item_Visibility)

## Replace year with corresponding number 
Train_Base$Outlet_Establishment_Year <- 2013 - Train_Base$Outlet_Establishment_Year

## Replace 'LF' and 'low fat' with 'Low Fat' and 'reg' with 'Regular'
Train_Base$Item_Fat_Content[Train_Base$Item_Fat_Content == 'LF'] <- 'Low Fat'
Train_Base$Item_Fat_Content[Train_Base$Item_Fat_Content == 'low fat'] <- 'Low Fat'
Train_Base$Item_Fat_Content[Train_Base$Item_Fat_Content == 'reg'] <- 'Regular'
Train_Base$Item_Fat_Content = droplevels(Train_Base$Item_Fat_Content)

## Replace missing values in Outle_Size by mode,?ĥβ???
Train_Base$Outlet_Size[Train_Base$Outlet_Size == ""] <- 'Median'

## ?R???h?l???]?l
Train_Base$Outlet_Size = droplevels(Train_Base$Outlet_Size)


## Convert Outlet_Location_Type into numeric
Train_Base$Outlet_Size = as.numeric(Train_Base$Outlet_Size)

## Create Item Volume Sold.
Train_Base$Item_Volume = Train_Base$Item_Outlet_Sales/Train_Base$Item_MRP
Train_Base$Item_Volume = round(Train_Base$Item_Volume)
Train_Base$Item_Outlet_Sales = NULL


## Drop Outlet Size
Train_Base =  subset(Train_Base,select = -c(Item_Identifier))

########################### Test #################################

## Replace Missing vaues in Item_Weight in other data
Test_Base$Item_Weight <- combined$Item_Weight[8523:14203]

## REplace 0 in Item_Visibility by Mean
Test_Base$Item_Visibility[Test_Base$Item_Visibility == 0]<- mean(Test_Base$Item_Visibility)

## Replace year with corresponding number 
Test_Base$Outlet_Establishment_Year <- 2013 - Test_Base$Outlet_Establishment_Year

## Replace 'LF' and 'low fat' with 'Low Fat' and 'reg' with 'Regular'
Test_Base$Item_Fat_Content[Test_Base$Item_Fat_Content == 'LF'] <- 'Low Fat'
Test_Base$Item_Fat_Content[Test_Base$Item_Fat_Content == 'low fat'] <- 'Low Fat'
Test_Base$Item_Fat_Content[Test_Base$Item_Fat_Content == 'reg'] <- 'Regular'
Test_Base$Item_Fat_Content = droplevels(Test_Base$Item_Fat_Content)

## Replace missing values in Outle_Size by mode
Test_Base$Outlet_Size[Test_Base$Outlet_Size == ""] <- 'Median'
Test_Base$Outlet_Size = droplevels(Test_Base$Outlet_Size)

## Convert Outlet_Location_Type into numeric
Test_Base$Outlet_Size = as.numeric(Test_Base$Outlet_Size)

## Create Item Volume Sold.
Test_Base["Item_Volume"] = Test_Base$Item_Outlet_Sales/Test_Base$Item_MRP
Test_Base$Item_Volume = round(Test_Base$Item_Volume)
Test_Base$Item_Outlet_Sales = NULL

## Drop Outlet Size
Test_Base =  subset(Test_Base,select = -c(Item_Identifier))

## Create One Hot Data Train
features <- setdiff(names(Train_Base), "Item_Volume")

onehot <- vtreat::designTreatmentsZ(Train_Base, features, verbose = FALSE)
onehot_value <- onehot %>%
  magrittr::use_series(scoreFrame) %>%
  dplyr::filter(code %in% c("clean", "lev")) %>%
  magrittr::use_series(varName)

Train_Base_Predict <- vtreat::prepare(onehot,Train_Base,varRestriction = onehot_value) %>% as.data.frame()
Train_Base_Predict["Item_Volume"] = Train_Base["Item_Volume"]

## Create One Hot Data Test

features <- setdiff(names(Test_Base), "Item_Volume")

onehot <- vtreat::designTreatmentsZ(Test_Base, features, verbose = FALSE)
onehot_value <- onehot %>%
  magrittr::use_series(scoreFrame) %>%
  dplyr::filter(code %in% c("clean", "lev")) %>%
  magrittr::use_series(varName)

Test_Base_Predict <- vtreat::prepare(onehot,Test_Base,varRestriction = onehot_value) %>% as.data.frame()


##Cross-validation
dt_list <- c()
rf_list <- c()
lr_list <- c()
xgb_list <- c()

#Randomly shuffle the data
Train_Base_Predict<-Train_Base_Predict[sample(nrow(Train_Base_Predict)),]
for(k in 5:10){
  message("K fold: ", k)
  fold <- k
  folds <- cut(seq(1,nrow(Train_Base_Predict)),breaks=fold,labels=FALSE)
  total_dt <- 0
  total_rf <- 0
  total_lr <- 0
  total_xgb <- 0 
  
  for(i in 1:fold){
    message("Round: ", i)
    validationDataIndexes <- which(folds==i,arr.ind=TRUE)
    validationData <- Train_Base_Predict[validationDataIndexes, ]
    #print(dim(validationData))
    trainData <- Train_Base_Predict[-validationDataIndexes, ]
    #print(dim(trainData))
    
    ## Decision Tree
    ctrl = rpart.control(maxdepth = 4,minsplit = 20,minbucket = 7) 
    dt1 = rpart(Item_Volume ~. , data = trainData,parms =  c(split = "gini"),control = ctrl)
    validation = predict(dt1,newdata = validationData[1:40])
    print(rmse(validationData$Item_Volume*validationData$Item_MRP,validation*validationData$Item_MRP))
    total_dt = total_dt+rmse(validationData$Item_Volume*validationData$Item_MRP,validation*validationData$Item_MRP)
    
    ## Random Forest
    rf1 =randomForest(Item_Volume ~ . ,data = trainData,ntree = 100,mtry = 30,maxnodes = 10)
    validation = predict(rf1,newdata = validationData[1:40])
    print(rmse(validationData$Item_Volume*validationData$Item_MRP,validation*validationData$Item_MRP))
    total_rf = total_rf+rmse(validationData$Item_Volume*validationData$Item_MRP,validation*validationData$Item_MRP)
    
    ## Linear Regression with multiple variables
    lr1 =lm(Item_Volume ~ . ,data = trainData)
    validation = predict(lr1,newdata = validationData[1:40])
    print(rmse(validationData$Item_Volume*validationData$Item_MRP,validation*validationData$Item_MRP))
    total_lr = total_lr+rmse(validationData$Item_Volume*validationData$Item_MRP,validation*validationData$Item_MRP)
    
    ## XGbroost
    param_list = list(
      objective = "reg:linear",
      eta=0.01,
      gamma = 1,
      max_depth=6,
      subsample=0.8,
      colsample_bytree=0.5
    )
    dtrain = xgb.DMatrix(data = as.matrix(trainData[1:40]), label= trainData$Item_Volume)
    dtest = xgb.DMatrix(data = as.matrix(validationData[1:40]))
    xgb_model = xgboost(data = dtrain, params = param_list, nrounds = 430)
    validation <- predict(xgb_model, dtest)
    print(rmse(validationData$Item_Volume*validationData$Item_MRP,validation*validationData$Item_MRP))
    total_xgb = total_xgb+rmse(validationData$Item_Volume*validationData$Item_MRP,validation*validationData$Item_MRP)
  }
  print("average rmse:")
  print(total_dt/fold)
  print(total_rf/fold)
  print(total_lr/fold)
  print(total_xgb/fold)
  
  dt_list <- c(dt_list,total_dt/fold)
  rf_list <- c(rf_list,total_rf/fold)
  lr_list <- c(lr_list,total_lr/fold)
  xgb_list <- c(xgb_list,total_xgb/fold)
}

out_data<-data.frame(K_fold=c(5,6,7,8,9,10), Decision_Tree=dt_list,  Random_Forest=rf_list, Linear_Regression=lr_list, XGbroost=xgb_list, stringsAsFactors = F)
print(out_data)
write.csv(out_data, file="k_fold.csv", row.names = F, quote = F)


## Decision Tree
ctrl = rpart.control(maxdepth = 4,minsplit = 20,minbucket = 7) 
dt1 = rpart(Item_Volume ~. , data = Train_Base_Predict,parms =  c(split = "gini"),control = ctrl)
PredictTree1 = predict(dt1,newdata = Test_Base_Predict[1:40])
Sub_Base_Tree = Sub_Base
Sub_Base_Tree$Item_Outlet_Sales = PredictTree1*Test_Base_Predict$Item_MRP
write.csv(Sub_Base_Tree, file = "Sub_v1_Tree.csv", row.names = F, quote = F)

## Random Forest
set.seed(44)
rf1 =randomForest(Item_Volume ~ . ,data = Train_Base_Predict,ntree = 500,mtry = 30,maxnodes = 40)

PredictForest1 <- predict(rf1, newdata = Test_Base_Predict[1:40])
Sub_Base_RF = Sub_Base
Sub_Base_RF$Item_Outlet_Sales = PredictForest1*Test_Base_Predict$Item_MRP
write.csv(Sub_Base_RF, file = "Sub_v1_RF.csv", row.names = F, quote = F)

## Linear Regression with multiple variables
lr1 =lm(Item_Volume ~ . ,data = Train_Base_Predict)
PredictLinear1 <- predict(lr1, newdata = Test_Base_Predict[1:40])
Sub_Base_LM = Sub_Base
Sub_Base_LM$Item_Outlet_Sales = PredictLinear1*Test_Base_Predict$Item_MRP
Sub_Base_LM$Item_Outlet_Sales
write.csv(Sub_Base_LM, file = "Sub_v1_LM.csv", row.names = F, quote = F)

## XGbroost
param_list = list(
  objective = "reg:linear",
  eta=0.01,
  gamma = 1,
  max_depth=6,
  subsample=0.8,
  colsample_bytree=0.5
)
dtrain = xgb.DMatrix(data = as.matrix(Train_Base_Predict[1:40]), label= Train_Base_Predict$Item_Volume)
dtest = xgb.DMatrix(data = as.matrix(Test_Base_Predict[1:40]))
xgb_model = xgboost(data = dtrain, params = param_list, nrounds = 430)
PredictXG1 <- predict(xgb_model, dtest)
Sub_Base_XG = Sub_Base
Sub_Base_XG$Item_Outlet_Sales = PredictXG1*Test_Base_Predict$Item_MRP
write.csv(Sub_Base_XG, file = "Sub_v1_XG.csv", row.names = F, quote = F)
