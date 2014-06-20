The code in run_analysis.r works with the dataset provided for Getting and Clearing Data course Project available at 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

the specific steps are:
- read the files into workspace, 
- clean the variable names provided in features.txt, 
- combine the data for test and train subject in one data frame, 
- select variables for mean and standard deviation
- create meaningful names for variables and factors
- create a new data frame containing means of the variables for each subject and activity level.