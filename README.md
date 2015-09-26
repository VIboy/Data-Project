---
title: "README.md"
author: "VIboy"
date: "24 September 2015"
output: html_document
---

## README.md

This document explains how all of the scripts work and how they are connected.

The first step is to set the working directory using the following code:

> setwd("~/Data Cleaning")

where "~/data Cleaning" is the path of my working directory.
> library(plyr)
library(dplyr)

Then the following script was run to download the file from the internet into a subdirectory "data" that I have created in the working directory:

> if(!file.exists("data")) {
  dir.create("data")
} 
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#Creates a subdirectory called "data" in your working directory
download.file(fileUrl,destfile = "./data/project1.zip")

Next both the training and test data sets were downloaded into files named "rawTrain" and "rawTest" respectively, using the read.table() function and check their dimensions and structure to understand them better:

> rawTrain<-read.table("./train/X_train.txt") #raw training set
dim(rawTrain) #7352  by 561
str(rawTrain)
rawTest<-read.table("./test/X_test.txt") #raw test set
dim(rawTest) # 2947 561
str(rawTest)

As stated in the file "features_info.txt", the complete list of variables of each feature vector is available in 'features.txt'. So the following script was used to download the 'features.txt' file  which will be used as the column names for both the training and test sets:

> features<-read.table("./features.txt")# Names of the feature vector which are the columns of the dataset
dim(features)
features[1:10,1:2]
features$V2<-gsub("-","",features$V2) #Replace the "-" with no spacing

The last line of above r code was used to remove the redundant '-' and to reduce the width of the columns. Hopefully it also helps to enhance the descriptive names of the variables, eg. from 'tBodyAcc-mean()-X' to 'tBodymean()X'. 
Then the following lines of r code were used to add the descriptive column names to both the training and test sets. These column names were downloaded from the features.txt file:

> colnames(rawTrain)<-features$V2 #Put in the column names for training set
rawTrain[1,1:10]
colnames(rawTest)<-features$V2 #Put in column names for rawTest
rawTest[1,1:10]

The Subject ids (ranging from 1-30) for the training set, were downloaded from the 'subject_train.txt' file. This will be the row of observations showing which Subject was associated with which Activity, and the relevant measurements in the variables. Next, the Subject id for the test set was downloaded from the subject_test.txt file.

> subjectidTrain<-read.table("./train/subject_train.txt") #Range 1:30. Subject id for training set.
dim(subjectidTrain) # 7352 1
subjectIdTest<-read.table("./test/subject_test.txt") #Subject id for test set
dim(subjectIdTest) # 2947 1

The labels for the Activity column for both training and test sets were also downloaded using the read.table() function. Then both the column names for Activity and Subject were added to their respective files before being combined into the training set using cbind().

> trainLabels<-read.table("./train/y_train.txt") #Range 1:6. Activity Labels for training set.
dim(trainLabels) # 7352 rows 1 column
colnames(trainLabels)<-"Activity" #This gives the column name (Activity) to trainLabels
head(trainLabels) # starts with 5,5,5,5,5 under column name V1
trainSet2[1:6,1:6]
colnames(subjectidTrain)<-"Subject" #Gives column name (Subject) to subjectidTrain
trainSet2<-cbind(subjectidTrain,trainLabels,rawTrain) #Complete training set with names of 'Subject' and 'Activity' in columns 1 & 2.
dim(trainSet2) #7352 rows  563 columns

The result is a training set with all the relevant column names starting from the Subject and associated Activity, and then the measurement variables giving a total of 563 columns.
The same process was done to the test set, where the Subject and Activity columns were cbind into the data set, so that the relevant column names for all the variables were in place using the following code:

> testLabels<-read.table("./test/y_test.txt") #range 1:6 Activity labels for test set.
dim(testLabels) #2947 by 1
colnames(subjectIdTest)<-"Subject"
colnames(testLabels)<-"Activity"
testSet1<-cbind(subjectIdTest,testLabels,rawTest) #Complete test set with Subject id and Activity columns.
testSet1[1:5,1:6] 
dim(testSet1) #2947 observations  563 variables/columns

In the process, we checked that the script was running correctly by examining the first few rows and columns of the training and test sets.
The next few steps were done to merge the training and test sets as required to form one data set, adjust the Subject id and Activity Labels in sequential order before selecting only the mean and standard deviation of each of the variables. The code for doing so is shown below:

> mergeData<-rbind(trainSet2,testSet1) # Merged data set of 10299 rows and 563 columns
dim(mergeData)
# Subset by selecting only the mean and standard deviation in the column names
> mergeData1<-mergeData[,c("Subject","Activity",colnames(mergeData)[grep("mean|std", colnames(mergeData))])]
dim(mergeData1) #The new data set with 10299 rows and 81 columns
mergeData1[1:5,1:5]

So this will be the new tidy data set with 10299 observations and 81 columns of the relevant measurement variables.
We also looked at the first 5 rows and five of the middle columns of the subset of the merged data to make sure that everything was correct.
The course project only required the measurements on the mean and standard deviation for each measurement. However, it was noticed that there was a 'meanFreq' component in the merged data above. Therefore, the variables with a meanFreq component were removed to have the required data set of 10299 observations and 68 columns of the mean and standard deviation for each measurement. This updated merged data set was then arranged in sequential order of Subject (from 1:30) and Activity (1:6).

> freqIndex<-grep("meanFreq",colnames(mergeData1)) # Gives column positions of meanFreq 
freqIndex
mergeData2<- mergeData1[c(-freqIndex)] #New data set without meanFreq()
dim(mergeData2) # 10299 68

# Arrange data in order of Subject and Activity
> mergeData2<- arrange(mergeData1,Subject, Activity) #DF with arranged data
mergeData2[1:6,1:6]

In order to give descriptive activity names to the name of the activities in the data set,  the Activity code from 1:6 were converted to "Walk", "WalkUp","WalkDown", "Sit","Stand", "Lay" respectively. Before that, the Activity labels for the training and test sets were combined since we now have a merged set containing both the above data sets. Just to make sure that the Activity codes of 1:6 have been replaced, the first few rows of the data set was inspected.

# Use this to convert the Activity codes to Activity names.
> ActivityLabels<-rbind(trainLabels,testLabels) # Combine Activity codes for training and test sets first
dim(ActivityLabels) # 10299 1
Activities<-c("Walk","WalkUp","WalkDown","Sit","Stand","Lay")
mergeData2$Activity<-Activities[ActivityLabels$Activity]
mergeData2[1:10,1:10]


The final step in this whole process was to group the data set according to Subject and Activity, and then compute the correspoding average value of the resultant grouping so that the new tidy data set has the average value of each variable for each activity and each subject. The code to do this is shown here:

#Group by Subject & activity and caculate mean of each column

> mergeData3<-group_by(mergeData2, Subject, Activity) %>% summarise_each(c("mean"))
dim(mergeData3) # 180 observations 68 columns
mergeData3[1:5,1:5] # to check how the new data set looks.

The final tidy data set consists of 180 observations based on 30 Subjects who participated and the 6 Activities. There were 68 columns with the first two for the Subject and Activity, and 66 of the average value of mean and standard deviation of each of the measurement variables.
In the final data set, it was noted that there were six columns where part of the column name has the word "Body"  repeated as in "BodyBody". So these were replaced by just "Body" in line with the rest of the other variable names. The column names were also modified to reflect that these are the average values with the text 'ave_' at the beginning of the column name, and symbol "()"  was also removed. The following script represent an attempt to enhance the column names to make it more descriptive to make further study and analyses easier. For eg., in the  process of putting in "ave_", it was noted that the Subject and Activity column also had the letters "ave_" attached and so the original column names for these 2 first columns were put back.

# Need to put these codes earlier and select which ones to replace 
> colnames(mergeData3)<-sub("()","ave_",colnames(mergeData3)) # Adds ave_ to the beginning  
colnames(mergeData3)[1:2]<- c("Subject", "Activity") #Put back correct colnames for Subject and Activity
colnames(mergeData3)<-gsub("\\()","-",colnames(mergeData3))
colnames(mergeData3)<-sub("BodyBody","Body",colnames(mergeData3)) # Replace colnames with BodyBody with Body

> write.table(mergeData3, "tidyData.txt", sep=",", row.name=FALSE) # to print out the new tidy data set to a txt file
