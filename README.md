# DataCleanProgramAssign
This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Downloads the dataset if it does not already exist in the working directory
2. Loads both the training and test datasets, feature and activity information.
3. Merges activity and subject data for each dataset and then merges the training and test datasets.
4. Subsets the dataset based on mean and standard deviation variables (only variables with mean() or std() in name taken).
5. Converts the `activity` and `subject` columns into factors, renaming the activity labels to be descriptive.
6. Creates a tidy dataset that consists of the average (mean) value of each
   variable for each subject and activity pair.

The end result is shown in the file `TidyDat.txt`.