##The library used in this operation is dtplyr ; data.table + dplyr code now lives in dtplyr package.

#install.packages("dtplyr")
library(dtplyr)

##Read Supporting data
##load data into variables Samsungfeatures and  Samsungactivity_labels.

##setwd("C:/ravi/DataScience/rwd")
##Assumption : "data/UCI HAR Dataset" present in the working directory.

Samsungfeatures <- read.table("data/UCI HAR Dataset/features.txt")
Samsungactivity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt", header = FALSE)

##Read training data and save into variables Samsungsubject_train, SamsungX_train, Samsungy_train

Samsungsubject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
SamsungX_train <- read.table("data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
Samsungy_train <- read.table("data/UCI HAR Dataset/train/y_train.txt", header = FALSE)

##Read test data and save into variables Samsungsubject_test, SamsungX_test, Samsungy_test

Samsungsubject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
SamsungX_test <- read.table("data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
Samsungy_test <- read.table("data/UCI HAR Dataset/test/y_test.txt", header = FALSE)

##1st step - Merge the training and the test sets to create one data set.
##combine the respective data in training and test data sets corresponding to subject, X and y.
##store the results in  Samsungsubject, SamsungX and Samsungy.

Samsungsubject <- rbind(Samsungsubject_train, Samsungsubject_test)
SamsungX <- rbind(SamsungX_train, SamsungX_test)
Samsungy <- rbind(Samsungy_train, Samsungy_test)

##The columns in the SamsungX data set can be named from the metadata in Samsungfeatures

colnames(SamsungX) <- t(Samsungfeatures[2])

##The data in Samsungsubject, SamsungX and Samsungy are merged and the complete data is now stored in SamsungData.

colnames(Samsungy) <- "Activity"
colnames(Samsungsubject) <- "Subject"
SamsungData <- cbind(SamsungX,Samsungy,Samsungsubject)

##2nd step - Extracts only the measurements on the mean and standard deviation for each measurement
##Extract the column names that have either mean or std in them.

SamsungColsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(SamsungData), ignore.case=TRUE)

SamsungColsWithMeanSTD

##1 to 561 (total 86) displayed

##Add activity and subject columns to the list and look at the dimension of SamsungData

MeanSTDColumns <- c(SamsungColsWithMeanSTD, 562, 563)

dim(SamsungData)
## [1] 10299   563

## create RequiredData with the selected columns in MeanSTDColumns. And again, we look at the dimension of MeanSTDColumns.

RequiredData <- SamsungData[,MeanSTDColumns]
dim(RequiredData)
## [1] 10299    88

## Stp 3 - Uses descriptive activity names to name the activities in the data set

##The activity field in RequiredData is of numeric type. We need to change its type to character so that it can accept activity names. 
##The activity names are taken from metadata activityLabels.

RequiredData$Activity <- as.character(RequiredData$Activity)
for (i in 1:6){
RequiredData$Activity[RequiredData$Activity == i] <- as.character(Samsungactivity_labels[i,2])
}

##We need to factor the activity variable, once the activity names are updated.

RequiredData$Activity <- as.factor(RequiredData$Activity)


## Step 4 - Appropriately labels the data set with descriptive variable names
##Here are the names of the variables in RequiredData

names(RequiredData)

##By examining RequiredData, we can say that the following acronyms can be replaced:
##Acc can be replaced with Accelerometer
##BodyBody can be replaced with Body
##Character f can be replaced with Frequency
##Character t can be replaced with Time
##Gyro can be replaced with Gyroscope
##Mag can be replaced with Magnitude

names(RequiredData)<-gsub("Acc", "Accelerometer", names(RequiredData))
names(RequiredData)<-gsub("Gyro", "Gyroscope", names(RequiredData))
names(RequiredData)<-gsub("BodyBody", "Body", names(RequiredData))
names(RequiredData)<-gsub("Mag", "Magnitude", names(RequiredData))
names(RequiredData)<-gsub("^t", "Time", names(RequiredData))
names(RequiredData)<-gsub("^f", "Frequency", names(RequiredData))
names(RequiredData)<-gsub("tBody", "TimeBody", names(RequiredData))
names(RequiredData)<-gsub("-mean()", "Mean", names(RequiredData), ignore.case = TRUE)
names(RequiredData)<-gsub("-std()", "STD", names(RequiredData), ignore.case = TRUE)
names(RequiredData)<-gsub("-freq()", "Frequency", names(RequiredData), ignore.case = TRUE)
names(RequiredData)<-gsub("angle", "Angle", names(RequiredData))
names(RequiredData)<-gsub("gravity", "Gravity", names(RequiredData))

##Here are the names of the variables in RequiredData after they have been modifed

names(RequiredData)

## Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#set Subject as a factor variable.

RequiredData$Subject <- as.factor(RequiredData$Subject)

RequiredData <- data.table(RequiredData)

##create tidyData as a data set with average for each activity and subject. 
##Then, we order the entries in tidyData and write it into data file  TidyData.txt that contains the final data.

tidyData <- aggregate(. ~Subject + Activity, RequiredData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "TidyData.txt", row.names = FALSE)
