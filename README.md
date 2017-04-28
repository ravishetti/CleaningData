#RY - Getting and Cleaning Data Course Project

##Assignment details

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Steps to work on the solution

Download the zip file and extract the content under the working directory of R Studio. After completing the extraction it will create "UCI HAR Dataset" folder along 
with the sub folders, training and test data.

Place run_analysis.R in the parent folder of "UCI HAR Dataset".

Run source("run_analysis.R"), then it will generate a new file TidyData.txt in your working directory.

I have commented all the steps clearly in the "run_analysis.R" program.

##Dependencies

"dtplyr" package has to be installed; data.table + dplyr code now lives in dtplyr package.
