library(randomForest)
library(caret)
library(onehot)
library(ggplot2)
library(Metrics)
library(tree)
library(rpart)
library(h2o)
library(xgboost)
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

train = read.table("data/Train.csv", header = T, sep = ",")

train$Outlet_Size = ifelse(train$Outlet_Size == "", 
                           "Medium", train$Outlet_Size)


outletsize_bysales = train %>% group_by(Outlet_Size) %>% 
  summarise_at(vars(Item_Outlet_Sales), funs(Count = n(),Sales_Mean = mean))


# Visualing Outlet_Size with Mean of Item_Outlet_Sales
j5 <- ggplot(outletsize_bysales, aes(Outlet_Size, Sales_Mean)) + 
  geom_bar(stat='summary', fun.y='mean',fill='slateblue1',color='black') + 
  geom_point() + 
  geom_text(aes(label = ceiling(Sales_Mean)), vjust=-0.3, size=3.5) + 
  ggtitle("Outlet Size Vs Sales") + 
  theme(plot.title = element_text(hjust = 0.5))

plot_grid(j5)


# Continuous Data Analysis (Univariate) Creatin Histograms

h1 <-  ggplot(train,aes(Item_Visibility))+
  geom_histogram(bins = 100,binwidth=0.01,color='Black',fill='Sky Blue') +
  ylab('Count') +
  ggtitle("Item Visibility Count") +
  theme(plot.title = element_text(hjust = 0.5))

h2 <- ggplot(train,aes(Item_Weight)) +
  geom_histogram(bins = 100,color='Black',fill='Sky Blue') +
  ylab('Count') + 
  ggtitle("Item Weight Count") + 
  theme(plot.title = element_text(hjust = 0.5))

h3 <- ggplot(train,aes(Item_MRP)) + 
  geom_histogram(bins = 100,color='Black',fill='Sky Blue') + 
  ylab('Count') + 
  ggtitle("Item MRP Count") + 
  theme(plot.title = element_text(hjust = 0.5))

# Creating a canvas and displaying the plots
second_row_2 <-  plot_grid(h1, h2, ncol = 2)
plot_grid(h3, second_row_2, nrow = 2)

ggplot(train, aes(Item_Visibility, Item_MRP)) + geom_point(aes(color = Item_Type)) +
  scale_x_continuous("Item Visibility", breaks = seq(0,0.35,0.05))+
  scale_y_continuous("Item MRP", breaks = seq(0,270,by = 30))+ 
  theme_bw() + labs(title="Scatterplot") + facet_wrap( ~ Item_Type)

ggplot(train, aes(Item_Visibility, Item_MRP)) + geom_point(aes(color = Item_Type)) +
  scale_x_continuous("Item Visibility", breaks = seq(0,0.35,0.05))+
  scale_y_continuous("Item MRP", breaks = seq(0,270,by = 30))+
  theme_bw() + labs(title="Scatterplot")

outletyear_bysales = train %>% group_by(Outlet_Establishment_Year) %>% 
  summarise_at(vars(Item_Outlet_Sales), funs(Count = n(),Sales_Mean = mean))

j9 <- ggplot(outletyear_bysales, aes(factor(Outlet_Establishment_Year), Sales_Mean)) + 
  geom_bar(stat='summary', fun.y='mean',fill='slateblue1',color='black') + 
  geom_point() + 
  geom_text(aes(label = ceiling(Sales_Mean)), vjust=-0.3, size=3.5) + 
  xlab('Outlet_Establishment_Year') + 
  ggtitle("Outlet Establishment Year Vs Sales") + 
  theme(plot.title = element_text(hjust = 0.5))

plot_grid(j9)

fat_bysales <-  train %>% group_by(Item_Fat_Content) %>% 
  summarise_at(vars(Item_Outlet_Sales), funs(Count = n(),Sales_Mean = mean))
# Visualing Item_Fat_Content with Mean of Item_Outlet_Sales
j1 <- ggplot(fat_bysales, aes(Item_Fat_Content, Sales_Mean)) + 
  geom_bar(stat='summary', fun.y='mean',fill='slateblue1',color='black') + 
  geom_point() + 
  geom_text(aes(label = ceiling(Sales_Mean)), vjust=-0.3, size=3.5) + 
  ggtitle("Item Fat Content Vs Sales") + 
  theme(plot.title = element_text(hjust = 0.5))

# Visualing Item_Fat_Content with Count of Item_Outlet_Sales
j2 <- ggplot(fat_bysales, aes(Item_Fat_Content, Count)) + 
  geom_bar(stat='summary', fun.y='mean',fill='slateblue1',color='black') + 
  geom_point() + 
  geom_text(aes(label = ceiling(Count)), vjust=-0.3, size=3.5) + 
  ggtitle("Item Fat Content Vs Count") + 
  theme(plot.title = element_text(hjust = 0.5))

graph <- plot_grid(j1,j2,ncol=2)
plot_grid(graph)

type_bysales <-  train %>% group_by(Item_Type) %>% 
  summarise_at(vars(Item_Outlet_Sales), funs(Count = n(),Sales_Mean = mean))

# Visualing Item_Type with Mean of Item_Outlet_Sales
j3 <- ggplot(type_bysales, aes(Item_Type, Sales_Mean)) + 
  geom_bar(stat='summary', fun.y='mean',fill='slateblue1',color='black') + 
  geom_point() + 
  geom_text(aes(label = ceiling(Sales_Mean)), vjust=-0.3, size=3.5) + 
  ggtitle("Item Type Vs Sales") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme(axis.text.x = element_text(angle=45,vjust=0.5))
plot_grid(j3)

outletsize_bysales = Train_Base %>% group_by(Outlet_Size) %>% 
  summarise_at(vars(Item_Outlet_Sales), funs(Count = n(),Sales_Mean = mean))


# Visualing Outlet_Size with Mean of Item_Outlet_Sales
j5 <- ggplot(outletsize_bysales, aes(Outlet_Size, Sales_Mean)) + 
  geom_bar(stat='summary', fun.y='mean',fill='slateblue1',color='black') + 
  geom_point() + 
  geom_text(aes(label = ceiling(Sales_Mean)), vjust=-0.3, size=3.5) + 
  ggtitle("Outlet Size Vs Sales") + 
  theme(plot.title = element_text(hjust = 0.5))

plot_grid(j5)