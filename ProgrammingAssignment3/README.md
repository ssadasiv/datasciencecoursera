==================================================================
Getting and Cleaning Data - Programming Assignment
==================================================================
run_analysis.R is the script used to read, clean and calculate the final results.

There are 5 steps in this script and each one is briefly described below:

Step 1: Reads the data for X, Y and Subject and combines the train and test data for each group.

Step 2: Sifts through the data and picks out standard deviation and mean. It also tidies the labels and converts the
data into lower case.

Step 3: Further cleans the data removing "-".

Step 4: Column binds all the three sets in the order of subject, activity and measurements. Writes the cleaned
data to a file called CleanedData.txt

Step 5: Calculates the number of activities, subjects and variables and then in a loop creates the data for the
final output. It then writes the data to a file called CleanedWithAverages.txt

==================================================================
