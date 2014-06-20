# You should create one R script called run_analysis.R that does the following. 

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each 
# activity and each subject. 

## Get data from test condition
# read the data
subject_test<-read.table("test/subject_test.txt")
y_test<-read.table("test/y_test.txt")
x_test<-read.table("test/x_test.txt")

# clean variable names to make them readiböle in R
features<-read.table("features.txt")
features<-gsub("-",".",features[,2])
features<-gsub(",",".",features)
features<-gsub("()","",features, fixed=TRUE)
features<-gsub(")","_",features, fixed=TRUE)
features<-gsub("(","_",features, fixed=TRUE)


# create names
names(y_test)<-c("Activity")
names(x_test)<-features
names(subject_test)<-"Subject.id"

# merge test data
subject_data_test<-cbind(subject_test,y_test)

## get data for train condition
# read the data
subject_train<-read.table("train/subject_train.txt")
y_train<-read.table("train/y_train.txt")
x_train<-read.table("train/x_train.txt")

# create train names
names(y_train)<-c("Activity")
names(x_train)<-features
names(subject_train)<-"Subject.id"

# merge train data
subject_data_train<-cbind(subject_train,y_train)

## merge test and train data
x_data<-rbind(x_test,x_train)
end<-length(x_data)
x_data[, 1:end] <- sapply(x_data[, 1:end], as.numeric)
subject_data<-rbind(subject_data_test, subject_data_train)

## subset variables for mean and std
mean_names <- grepl("mean", features)==TRUE
sd_names<- grepl("std", features)==TRUE
x_data_mean <- x_data[,mean_names]
x_data_sd<-x_data[, sd_names]
x_data_new<-cbind(x_data_mean,x_data_sd)

# add subjects and experiment information
data<-cbind(subject_data,x_data_new)

#  create new data frame with means for each subject and activity
aggdata <-aggregate(data, by=list(Subject.id,Activity), FUN=mean, na.rm=TRUE)

# make new names for means of all variables
end<-length(aggdata)
oldnames<-names(aggdata[,5:end])
newnames<-paste("mean",oldnames, sep=".")

# rename activity factors
library(plyr)
aggdata$Activity<-mapvalues(aggdata$Activity, 
                              from=c(1,2,3,4,5,6), 
                              to=c("Walking","Walking_Upstairs","Walking_Downstairs",
                                   "Sitting","Standing","Laying"))

# rename new means of the variables columns
names(aggdata)<-c("group.1", "group.2","Subject.id", "Activity",newnames)

# Final tidy data set (remove two group columns created by aggregate)
tidydata<-aggdata[,3:end]

# write files for submission
write.table(tidydata, file="tidydata.txt")
write.table(names(tidydata), file="CodeBook2.md")

