## Getting and Cleaning Data Project

Turner Gutmann

### Description
This codebook describes where the data came from, what data files were chosen, which variables are selected from those files, and the transformations performed on all that stuff.
### Source Data
The UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
[Raw source data is here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Data Set Information
This data is sensor signals from 30 subjects who wore Samsung devices that had gyroscopes and accelerometers in them.

### Attribute Information
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### 1. [Read in and] Merge Training and Test data sets to create one Final data set
After unzipping the data set, putting all text files in one folder and setting the source directory for the files, read into tables the data located in
- features.txt
- activity_labels.txt
- subject_train.txt
- X_train.txt
- y_train.txt
- subject_test.txt
- X_test.txt
- y_test.txt

Assign column names and merge to create one data set.

## 2. Extract only the measurements on the mean and standard deviation for each measurement.  
Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns
Subset finalData table to pull in just Ids and mean and std_dev columns

## 3. Use descriptive activity names to name the activities in the data set
Merge the finalData set with acitivityType add a column with activity names descriptives

## 4. Appropriately label the data set with descriptive activity names.
Make pretty variable names using gsub
Reorder columns to put have first few columns be subjectId, activityId, then activityType

### Final variable names (column names in the final data set)
[1] "activityId"                      "subjectId"                      
 [3] "timeBodyAccMagnitudeMean"        "timeBodyAccMagnitudeStdDev"     
 [5] "timeGravityAccMagnitudeMean"     "timeGravityAccMagnitudeStdDev"  
 [7] "timeBodyAccJerkMagnitudeMean"    "timeBodyAccJerkMagnitudeStdDev" 
 [9] "timeBodyGyroMagnitudeMean"       "timeBodyGyroMagnitudeStdDev"    
[11] "timeBodyGyroJerkMagnitudeMean"   "timeBodyGyroJerkMagnitudeStdDev"
[13] "freqBodyAccMagnitudeMean"        "freqBodyAccMagnitudeStdDev"     
[15] "freqBodyAccJerkMagnitudeMean"    "freqBodyAccJerkMagnitudeStdDev" 
[17] "freqBodyGyroMagnitudeMean"       "freqBodyGyroMagnitudeStdDev"    
[19] "freqBodyGyroJerkMagnitudeMean"   "freqBodyGyroJerkMagnitudeStdDev"
[21] "activityType" 

## 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
Create a text output from the above final data set that has summarized the average for each variable measurement collected (mean and std dev) for each subject and activity type. This is tidy.txt in my repo.
