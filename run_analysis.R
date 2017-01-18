list.files()
setwd("/Users/ME/Desktop/Coursera/3 Getting and Cleaning Data/Week 4")
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

##1. Merges the training and the test sets to create one data set.
# Reading training tables:
setwd("/Users/ME/Desktop/Coursera/3 Getting and Cleaning Data/Week 4/UCI HAR Dataset/train")
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")
# Reading testing tables:
setwd("/Users/ME/Desktop/Coursera/3 Getting and Cleaning Data/Week 4/UCI HAR Dataset/test")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")
# Reading feature vector:
setwd("/Users/ME/Desktop/Coursera/3 Getting and Cleaning Data/Week 4/UCI HAR Dataset")
features <- read.table('features.txt')
# Reading activity labels:
setwd("/Users/ME/Desktop/Coursera/3 Getting and Cleaning Data/Week 4/UCI HAR Dataset")
activityLabels = read.table('activity_labels.txt')
# Assigning column names:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')
# Merging all data in one set:
merging_train <- cbind(y_train, subject_train, x_train)
merging_test <- cbind(y_test, subject_test, x_test)
Total_merging <- rbind(merging_train, merging_test)

## 2. Extracts only the measurements on the mean and standard deviation 
#     for each measurement.
colNames <- colnames(Total_merging)
mean_and_std <- (grepl("activityId" , colNames) | 
                         grepl("subjectId" , colNames) | 
                         grepl("mean.." , colNames) | 
                         grepl("std.." , colNames) 
    )
Mean_and_SD <- Total_merging[ , mean_and_std == TRUE]

    ## 3. Uses descriptive activity names to name the activities in the data set
Act_Names <- merge(Mean_and_SD, activityLabels, by='activityId', all.x=TRUE)

## 4. Appropriately labels the data set with descriptive variable names.
secTidySet <- aggregate(. ~subjectId + activityId, Act_Names, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

## 5. From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
