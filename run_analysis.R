getwd()

# load the required packages
library(dplyr)
library(data.table)
library(tidyr)
## download and unzip the data

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "Coursera_DS3_Final.zip", method = "curl")
unzip("Coursera_DS3_Final.zip")

##assign all dataframes

## feature and activity
features<-read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activity<-read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

## test data
XTest<- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
YTest<- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = c("code"))
SubjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"))

## train data
XTrain<- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
YTrain<- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = c("code"))
SubjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("subject"))


## merge the training and test datasets to create one data set

X <- rbind(XTrain, XTest)
Y <- rbind(YTrain, YTest)
Subject <- rbind(SubjectTrain, SubjectTest)
Merged_data <- cbind(Subject, Y, X)


## extracts only the measurements on the mean and 
## standard deviation for each measurement

#TidyData <- Merged_data %>% select(subject, code, contains("mean"), contains("std"))

TidyData <- Merged_data %>% select(subject, code, contains(c("mean", "std")))

## use descriptive activity names to name the activities in the data set

TidyData$code <- activity[TidyData$code, 2]


## appropriately lables the data set with descriptive variable names
TidyData <- rename(TidyData, "activity" = "code")
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

## from the data set in step 4, create a second independent tidy data set with 
## the average of each variable for each activity and each subject.

FinalData <- TidyData %>% group_by(subject, activity) %>%
        summarise_all(mean)
       
write.table(FinalData, "FinalData.txt", row.names = FALSE)

## final check stage
str(FinalData)

FinalData
