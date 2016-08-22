# **Note** This program depends on the dplyr package on your system


# 1. [Read in and] Merge Training and Test data sets to create one Final data set

# Set working directory. This assumes you've unzipped the UCI Machine Learning Data set 
# found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
# And that you'd moved all the text files into: "~/data/activity"

setwd("~/data/activity")

# Import training data

features     = read.table("features.txt",header=FALSE); #imports features.txt
activityType = read.table("activity_labels.txt",header=FALSE); #imports activity_labels.txt
subjectTrain = read.table("subject_train.txt",header=FALSE); #imports subject_train.txt
xTrain       = read.table("X_train.txt",header=FALSE); #imports x_train.txt
yTrain       = read.table("y_train.txt",header=FALSE); #imports y_train.txt

# Import the test data
subjectTest = read.table("subject_test.txt",header=FALSE); #imports subject_test.txt
xTest       = read.table("X_test.txt",header=FALSE); #imports x_test.txt
yTest       = read.table("y_test.txt",header=FALSE); #imports y_test.txt

# Assigin column names 
colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";

# Assign column names 
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";

# Merge yTrain, subjectTrain, and xTrain
trainingData = cbind(yTrain,subjectTrain,xTrain);

# Merge xTest, yTest and subjectTest data
testData = cbind(yTest,subjectTest,xTest);

# Append training and test data to create a final data set
finalData_full = rbind(trainingData,testData);

# Create a vector for the column names in the finalData, used later for column selection
colNames  = colnames(finalData_full);

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

# Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns
logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) 
                 & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) 
                 & !grepl("-std()..-",colNames));

# Subset finalData table to pull in just Ids and mean and std_dev columns
finalData = finalData_full[logicalVector==TRUE];


# 3. Use descriptive activity names to name the activities in the data set

# Merge the finalData set with acitivityType add a column with activity names descriptives
finalData = merge(finalData,activityType,by='activityId',all.x=TRUE);

# Updating the colNames vector 
colNames  = colnames(finalData);

# 4. Appropriately label the data set with descriptive activity names. 

# Make pretty variable names
for (i in 1:length(colNames)) 
{
    colNames[i] = gsub("\\()","",colNames[i])
    colNames[i] = gsub("-std$","StdDev",colNames[i])
    colNames[i] = gsub("-mean","Mean",colNames[i])
    colNames[i] = gsub("^(t)","time",colNames[i])
    colNames[i] = gsub("^(f)","freq",colNames[i])
    colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
    colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
    colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
    colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
    colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
    colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
    colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

# Reassigning the new descriptive column names to the finalData set
colnames(finalData) = colNames;

# Reorder columns to put have first few columns be subjectId, activityId, then activityType
library(dplyr)
finalData <- select(finalData, subjectId, activityId, activityType, everything())



# 5. Create a second, independent tidy data set with the average of each variable for each activity 
# and each subject. 

# Create the finalData_noAT data set without the activityType column
finalData_noAT  = finalData[,names(finalData) != 'activityType'];

# Summarizing the finalData_noAT table with the mean of each variable 
# for each activity and each subject

tidy <- aggregate(finalData_noAT[,names(finalData_noAT) != c('activityId','subjectId')],
                  by=list(activityId=finalData_noAT$activityId, subjectId = finalData_noAT$subjectId),mean);

tidy <- tidy[, c(3:22)]

# Merge tidy data set with activityType to include descriptive acitvity names
tidy <- merge(tidy,activityType,by='activityId',all.x=TRUE);

# Rearrange columns to make it more betterer to understand
tidy <- select(tidy, subjectId, activityId, activityType, everything())

# Sort by subject ID, then activity ID
tidy <- arrange(tidy, subjectId, activityId)

# Export the tidy data set 
write.table(tidy, './tidy.txt',row.names=FALSE);