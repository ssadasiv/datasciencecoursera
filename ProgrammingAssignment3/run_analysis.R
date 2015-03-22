## Script run_analysis.R
## This script reads, merges, extracts, labels and then creates a separate data set.
## There are five steps to this script and each one is labelled for clarity.
##

 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
## The file has been copied to the folder where this script resides.
##
## ## Step 1: Merges the training and the test sets to create one data set.
## Read and merge the files

XTrain <- read.table("train/X_train.txt")
XTest <- read.table("test/X_test.txt")
XData <- rbind(XTrain, XTest)

YTrain <- read.table("train/Y_train.txt")
YTest <- read.table("test/Y_test.txt")
YData <- rbind(YTrain, YTest)

STrain <- read.table("train/subject_train.txt")
STest <- read.table("test/subject_test.txt")
SData <- rbind(STrain, STest)

## Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement

## Read the features data
Features<- read.table("features.txt")

## We only want measurements on the mean and std. deviation. So check for these in Features
## check to see how mean and std appear in the table.
## myIndices should only have the data that has mean and std (with -mean and -std)

myIndices <- grep("-mean\\(\\)|-std\\(\\)", Features[,2])

## should get 10299 observations of 66 variables
XData <- XData[,myIndices]

## This for X, Y and Z
names(XData) <- Features[myIndices,2]
## put "" around the names
names(XData) <- gsub("\\(|\\)","",names(XData))
## change everything to lower case
names(XData)<- tolower(names(XData))

## Step 3 - Uses descriptive activity names to name the activities in the data set
## Read the activity file - should get 6 activities

myActivities <- read.table("activity_labels.txt")
## convert to lower case. There are six activities that we want placed instead of 1 to 6 
## the following sets the second column to be textual names and then replaces column one containing numbers
## with textual names.Remove the dash

myActivities[,2] = gsub("-","", tolower(as.character(myActivities[,2])))
YData[,1]=myActivities[YData[,1],2]

## Call Column 1 activity instead of V1
names(YData) <- "activity"

## Step 4 - Appropriately labels the data set with descriptive variable names
names(SData) <- "subject"
## So all three data sets are cleaned with appropriate column names and activity names
## column bind them together - subject, activity and then everything else

comboXYS<- cbind(SData,YData,XData)

## Now write to a file
write.table(comboXYS,"CleanedData.txt")

## Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of 
## each variable for each activity and each subject

## Get the number of activities. I know this from above, but just to be clean
numActivities = length(myActivities[,1])

## Get the number of people who were part of the experiment. Remember that each subject did six activities, so
## numbers will be repeated. We only want unique occurrences. As indicated in th Read me file, there were 30
## people who participated in this experiment

unqSubjects = unique(SData)[,1]
numSubjects = length(unique(SData)[,1])

## Create a data frame to store the results that will be written to a file.
myResult = comboXYS[1:(numSubjects*numActivities),]

## Get the number of variables
numVariables = dim(comboXYS)[2]

myIndex = 1

## for each individual
for(subject in 1:numSubjects)
{
  ## for each individual, each activity
  for(activity in 1:numActivities)
  {
    ## do the calculation
    myResult[myIndex,1] = unqSubjects[subject]
    myResult[myIndex,2] = myActivities[activity,2]
    tmp<-comboXYS[comboXYS$subject==subject & comboXYS$activity==myActivities[activity,2],]
    ## column one has the subject, column 2 has the activity
    ## store means from column 3 to number of numVariables (see above)
    myResult[myIndex, 3:numVariables] <- colMeans(tmp[,3:numVariables])
    myIndex=myIndex+1
  }
}
## We could be smart and order the table by subjects, activity and the rest.

write.table(myResult,"CleanedWithAverages.txt",row.name=FALSE)
