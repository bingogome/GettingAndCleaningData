# GettingAndCleaningData
This is the course project repo for the JHU "Getting and Cleaning Data"

The script processes the data in the folder "UCI HAR Dataset". First it merges the training and tesing data sets. It extracts only the mean and standard deviation data which in our case are those whose column names contain "mean" and "std". Finally it create a new tidy data set that is the summaized mean of each subject-activity pair.