##This script does the following on the UCI HAR Dataset:
##1.Merges the training and the test sets to create one data set.
##2.Extracts only the measurements on the mean and standard deviation for each measurement.
##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive variable names.
##5.From the data set in step 4, creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.

        
##Loading required packages
        library(plyr)
        library(dplyr)
        library(reshape2)

##Downloading the Data
        setwd("C:/Users/andre/Dropbox/DataScience/Assignments/DatCleanProgAs")
        if(!exists("./data")) {dir.create("data")}
        fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        if(!file_test("-f","./data/UCI HAR Dataset.zip")) {
                download.file(fileUrl, "UCI HAR Dataset.zip")
                unzip("./data/UCI HAR Dataset.zip", exdir = "./data")
        }
        
##Reading in the data
        xtrain <- read.table(".\\data\\UCI HAR Dataset\\train\\X_train.txt")
        ytrain <- read.table(".\\data\\UCI HAR Dataset\\train\\y_train.txt")
        xtest <- read.table(".\\data\\UCI HAR Dataset\\test\\X_test.txt")
        ytest <- read.table(".\\data\\UCI HAR Dataset\\test\\y_test.txt")
        subjecttrain <- read.table(".\\data\\UCI HAR Dataset\\train\\subject_train.txt")
        subjecttest <- read.table(".\\data\\UCI HAR Dataset\\test\\subject_test.txt")
        activitylabels <- read.table(".\\data\\UCI HAR Dataset\\activity_labels.txt")
        features <- read.table(".\\data\\UCI HAR Dataset\\features.txt")

##1. Compiling columns in x train and test then adding test to the bottom of train
        train <- cbind(subjecttrain, ytrain, xtrain)
        test <- cbind(subjecttest, ytest, xtest)
        dat <- rbind(train, test)
        

##2. Subsetting to extract only mean and standard deviation variables
        features$V2 <- as.character(features$V2)
        colnames(dat) <- c("subjectid","activity",features$V2)
        
        meanvar <- grep("mean\\()", colnames(dat))
        stdvar <- grep("std\\()", colnames(dat))
        index <- c(1,2,meanvar, stdvar)
        index <- sort(index)
        dat <- subset(dat,, select = index)
      
##3&4 Naming factors and cleaning variable names

        ##Converting activity labels to symbolless lower case
        activitylabels$V2 <- gsub("_","",tolower(activitylabels$V2))
        activitylabels$V2 <- as.character(activitylabels$V2)
        
        ##resetting first variables as factors
        dat$subjectid <- factor(dat$subjectid)
        dat$activity <- factor(dat$activity, levels = activitylabels$V1, labels = activitylabels$V2)

        ##Converting variable names to symbolless CamelCase
        colnames(dat) <- gsub("^t","time", colnames(dat))
        colnames(dat) <- gsub("^f","freq", colnames(dat))
        colnames(dat) <- gsub('\\-(\\w)', '\\U\\1', colnames(dat), perl=T)
        colnames(dat) <- gsub("-|,|\\(||\\)","", colnames(dat))

##5. Creating data set of averages of each variable by activity and subject using aggregate function

        TidyDat <- aggregate(dat[,3:ncol(dat)], 
                             by = list(subjectid = dat$subjectid, activity = dat$activity), mean)
        TidyDat <- dplyr::arrange(TidyDat, subjectid, activity)

##Saving the result
        write.table(TidyDat,"./DataCleanProgramAssign/TidyDat.txt",row.names = FALSE, quote = FALSE)
        

        