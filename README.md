The code reads the files X_train, and X_test, then it reads the subject_test, and subject_train, and put both into a data.frame
then it does the same with "y" files and put the data into a data frame, after it we put all the data into a dataset naming the columns with the y information

Then we extract the information about means and std usign grep function

Then we read activity_labels file and we use it to merge it with the DataSet naming the activities

Then we apporpritely label the data set using sub and gsub funtion

Arter all we use dplyr package functions to export a tidy dataset with the mean of each varible, grouped by Activity and subject




