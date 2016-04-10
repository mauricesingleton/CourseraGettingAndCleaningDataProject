# Getting and Cleaning Data Project
## coursera.org

#### Purpose 

The purpose of this project is to process a non-tidy dataset into a tidy dataset for analysis.
The data used is originally from the University of California at Irvine dataset for activity 
recognition using sensor data from smartphones.  Detailed information can be found at the following 
website:

  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


### Data Cleaning (run_analysis.R)

First, I delete all of the variables in the working space, then load the appropriate libraries that are used to 
simplify the analysis: 
  * readr and
  * dyplr.

Then set the working directory -- **this path should be edited by the user to the path they are using**

I was getting duplicate column name errors from the features.txt file, so I edited the features.txt file 
and saved it as  features2.txt in order to rename the "fBodyAcc-bandsEnergy..." fields, 
since the names repeat three times.  I appended a "-x" to the first set (lines 303-316); "-y" to 
the next set (lines 317-330) and "-z" to the third set (lines 331-344).  I'm not sure these are axis-based data, 
but it is probably a good assumption that they are.

For the activity, removed "WALKING_" from "WALKING_DOWNSTAIRS" and "WALKING_UPSTAIRS"
to leave "UPSTAIRS" and "DOWNSTAIRS" simply for future compact reporting.

In order to join the subject data with the "x" and "y" data, I created a new "rownumber" column in 
each dataset to allow a quick and easy join.

Note that instead of writing a parametized function to pull the test and train datasets, I chose simply to 
copy and edit the code.  Had there been three or more datasets, then a more logical path would have been to 
build one or more functions to handle the repetative data manipulation.

Before doing any heavy analysis on the datasets, I chose to remove the unwanted columns (by only keeping the 
key identifiers and those variables containg the strings "mean" or "std").  

Before merging the test and train data, I added a "testtrain" column to each dataset to allow easier analysis 
in the future, as the goal of the original project was likely to determine if you could predict the activity of 
the "test" cases based on the data from the "train" cases.  While, this could be done by building a map between 
the subjectid and test/train, I chose to include it here.  

The dplyr summarize_each function is used to calculate the mean for each of the filtered variables per user and 
activity type.  This data is exported as a table into "all_summary.txt", which can also be found in this repository.

