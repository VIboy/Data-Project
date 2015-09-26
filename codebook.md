---
title: "CodeBook"
author: "VIboy"
date: "24 September 2015"
output: word_document


## CodeBook

This codebook describes the variables, the data, and the work performed to clean up the raw data and turn it into a tidy dataset.

The raw data that was downloaded consists of a 561-feature vector with time and frequency domain variables. These were derived from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and t-Gyro-XYZ, and the acceleration signal that was separated into body and gravity acceleration signals: tBodyAcc-XYZ and tGravityAcc-XYZ. The body linear acceleration and angular velocity were then derived in time to obtain the Jerk signals: tBodyAccJerk-SYZ and tBodyGyroJerk-XYZ. Also computed were the following signals: tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag and tBodyGyroJerkMag. The time domain signals (with 't' prefix) were captured at a constant rate of 50 Hz and the frequency domain signals (with prefix 'f') were produced after a Fast Fourier Transform (FFT) was applied to some of the above signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag and fBodyGyroJerkMag signals.

In terms of units, the acceleration signals from the smartphone accelerometer are in standard gravity units 'g', which is m/s^2, while the angular velocity vector measured by the gyroscope for each window samle are in radians /second. However, all the features in the raw dataset have been normalized and bounded within the range of [-1,1].

The set of variables that were estimated from the above signals are:

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
*meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between two vectors.

In this project, we are only interested in the mean and standard deviation variables. Please note that there is a meanFreq() component that will come up when we do a selection of the mean variable, and should be removed.

The complete dataset that was downloaded consists of 2 folders ('train' and 'test' folders) which contain all the raw data, and 4 text files (README.txt, 'features_info.txt', 'features.txt' and 'activity_labels.txt'). The raw data consists of two sets of data: the training data(70%) and test data(30%). The training data has 7352 observations of 561 variables and the test set has 2947 observations of the same number(561) of variables. The 2 columns for the subject id(30) and activity labels(6) were also added to both the training and test sets giving a total of 563 columns to represent each variable in each of the raw data sets. The more descriptive names for the 563 columns were then added to make it easier for future study and analysis. So the first column is the Subject id ranging from 1-30 and the second column the Activity code, ranging from 1-6 for the activities of walking, walking upstairs, walking downstairs, sitting, standing and laying. The Activity codes related directly to the activities described above were not were replaced yet because these were used to arrange the order of the activities. These were replaced later for the activities of 1 = walking ("Walk"), 2 = walking upstairs ("WalkUp"),3 = walking down stairs ("WalkDown"),4 = sitting ("Sit"), 5 = standing ("Stand"), and 6 = laying ("Lay") after the datasets were merged. The 3 letters "ing" were removed in the column names for a shorter column width. This code replacement with descriptive names could hae been done either way - earlier like now or later. I decided to do it later.

The next step was to merge the training and test sets into one data set. This created a merged data set of 10299 observations and 563 columns. After merging the data sets, the next step was to extract "only the measurements on the mean and standard deviation for each measurement". After doing this, there were 81 columns if we include the 2 columns of subject and activity. Therefore, there were a total of 79 variables with the mean and standard deviation. However, on examining these 79 varriables, I noticed that there were 13 variables of 'meanFreq' which is not part of the mean and standard deviation values required for this project. These 13 variables were removed giving a net total of 66 variables plus the two id columns of 'Subject' and 'Activity' - a total of 68 columns.

We now have a clean and tidy set. In order to enhance the description of the Activty column, the descriptive names of the activities were put in to replace the related Activity code. Finally, the merged data set was transformed into a data set grouped by Subject and Activity, and the average of each of the measurement variables were computed. This resulted in an independent tidy data set with the average of each variable for each activity and each subject. The column names for the average of the variables were also modified to give more accurate and descriptive names to these newly derived variables. The column names were also cleaned up because there were 6 columns that had "BodyBody" as part of them. These were replaced by just "Body" for eg., from "ave_fBodyBodyAccJerkMagmean" to "ave_fBodyAccJerkMagmean". The "-" and "()" symbols were also removed. as these were seen to be redundant.
