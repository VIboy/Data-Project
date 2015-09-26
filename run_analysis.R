setwd("~/Data Cleaning")
if(!file.exists("data")) {
  dir.create("data")
} #Creates a subdirectory called "data" in your working directory

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl,destfile = "./data/project1.zip")   
dateDownloaded<-date()
dateDownloaded

library(dplyr)
rawTrain<-read.table("./train/X_train.txt") #raw training set
dim(rawTrain) #7352  by 561
str(rawTrain)
head(rawTrain)
tail(rawTrain)
rawTrain[1,1:10]
rawTest<-read.table("./test/X_test.txt") #raw test set
dim(rawTest) # 2947 561

features<-read.table("./features.txt")# Names of the feature vector which are the columns of the dataset
dim(features)
features[1:10,1:2]
features$V2<-gsub("-","",features$V2) #Replace the "-" with no spacing

# features$V2<-sub("()","ave_",features$V2) # Adds ave_ to the beginning    
# Do this before replacing "()" in features

#Modify column names in features before putting into the 2 data sets

colnames(rawTrain)<-features$V2 #Put in the column names for training set
rawTrain[1,1:10]
colnames(rawTest)<-features$V2 #Put in column names for rawTest
rawTest[1,1:5]

subjectidTrain<-read.table("./train/subject_train.txt") #Range 1:30. Subject id for training set.
dim(subjectidTrain) 
subjectIdTest<-read.table("./test/subject_test.txt") #Subject id for test set
dim(subjectIdTest) #2947 1

trainLabels<-read.table("./train/y_train.txt") #Range 1:6. Activity Labels for training set.
dim(trainLabels) # 7352 rows 1 column
str(trainLabels)
colnames(trainLabels)<-"Activity" #This gives the column name (Activity) to trainLabels
head(trainLabels) # starts with 5,5,5,5,5 under column name V1
trainSet2[1:6,1:6]

colnames(subjectidTrain)<-"Subject" #Gives column name (Subject) to subjectidTrain
trainSet2<-cbind(subjectidTrain,trainLabels,rawTrain) #Complete training set with names of 'Subject' and 'Activity' in columns 1 & 2.
dim(trainSet2) #7352 by 563

testLabels<-read.table("./test/y_test.txt") #range 1:6 Activity labels for test set.
dim(testLabels) #2947 by 1
str(testLabels) # 2947 obs of 1 variable, also starts with 5,5,5,5,5
colnames(subjectIdTest)<-"Subject"
colnames(testLabels)<-"Activity"
testSet1<-cbind(subjectIdTest,testLabels,rawTest) #Complete test set with Subject id and Activity columns.
testSet1[1:5,1:6]
dim(testSet1)

#Next step to merge the training and test sets. Then adjust id and/or Activity in sequential order.
#Then select a new dataset with mean and std.
mergeData<-rbind(trainSet2,testSet1) #Merged data set of 10299 rows and 563 columns
dim(mergeData)
mergeData[10295:10299,1:6] #tail end of merged dataset

#Sorting out the mean and std in features. Total of 46+33=79 variables with mean and std
# # This code not needed.
featuresMean <- features[grepl("mean",features$V2),]
dim(featuresMean) #46 2
head(featuresMean)
featuresStd <- features[grepl("std",features$V2),]
dim(featuresStd) #33 2
head(featuresStd)

# Subset by selecting only columns with 'mean' or 'std' in the column names
mergeData1<-mergeData[,c("Subject","Activity",colnames(mergeData)[grep("mean|std", colnames(mergeData))])]
dim(mergeData1) #10299 by 81
head(mergeData1,3)
 ## Hurray it works

# Remove meanFreq from the variables
freqIndex<-grep("meanFreq",colnames(mergeData1)) # Gives column positions of meanFreq 
freqIndex
mergeData2<- mergeData1[c(-freqIndex)] #New data set without meanFreq()
dim(mergeData2) # 10299 68

#Arrange data in order of Subject and Activity
dataArrange<- arrange(mergeData1,Subject, Activity) #DF with arranged data
dim(dataArrange)


# Use this to convert the Activity codes to Activity names.
ActivityLabels<-rbind(trainLabels,testLabels) # Combine Activity codes for training and test sets first
dim(ActivityLabels) # 10299 1
Activities<-c("Walk","WalkUp","WalkDown","Sit","Stand","Lay")
mergeData2$Activity<-Activities[ActivityLabels$Activity]

dim(mergeData2)
   
#Group by Subject & activity and caculate mean of each column
library(dplyr) # To use %>% function
mergeData3<-group_by(mergeData2, Subject, Activity) %>% summarise_each(c("mean"))
dim(mergeData3)
mergeData3[1:5,1:5]


colnames(mergeData3)<-sub("()","ave_",colnames(mergeData3)) # Adds ave_ to the beginning  
colnames(mergeData3)<-gsub("\\()","-",colnames(mergeData3))
colnames(mergeData3)<-sub("BodyBody","Body",colnames(mergeData3)) # Replace colnames with BodyBody with Body
# # The end - Need to change the Activity and column names accordingly # #



library(stringr)
library(reshape2)
library(plyr)


