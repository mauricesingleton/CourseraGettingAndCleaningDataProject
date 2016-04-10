## delete the variable space
rm(list=ls())

## set the working directory
setwd("~/R/Week4Assignment/UCI HAR Dataset")

## read the features and activities to be used data frame header names

features <- read_delim("features2.txt", col_names=c("featureid","featurename"), delim=" ")
activities <- read_delim("activity_labels.txt", col_names=c("activityid","activityname"), delim=" ")
activities$activityname <- gsub("WALKING_","",activities$activityname)

## read the test data and add rownumber index
subjects_test <- read_tsv("test/subject_test.txt",col_names="subjectid")
subjects_test$rownumber <- 1:nrow(subjects_test)

## read the test data and add rownumber indices 
x_test <- read_fwf("test/x_test.txt", fwf_widths(rep(16, times=561), col_names=features$featurename))
x_test <- x_test[,grep("mean|std", features$featurename)]
x_test$rownumber <- 1:nrow(x_test)

#x_test$testtrain <- "test"

## Read the test data and add column to indicate test vs train so this can be used in later analyses

y_test <- read_tsv("test/y_test.txt", col_names="activityid")
y_test$rownumber <- 1:nrow(y_test)
y_test$testtrain <- "test"
y_test <- y_test %>% left_join(subjects_test, by=c("rownumber" = "rownumber"))
y_test <- y_test %>% left_join(activities, by=c("activityid" = "activityid"))

all_test <- left_join(y_test, x_test, by = c("rownumber" = "rownumber"))

## Note that if there were more than two datasets, it would be more efficient to build the 
## train and test datasets in a called function.  But since there are only two, it is just 
## as easy to cut, paste and edit.
## read the test data and add rownumber indices and column to indicate test vs train

subjects_train <- read_tsv("train/subject_train.txt",col_names="subjectid")
subjects_train$rownumber <- 1:nrow(subjects_train)


x_train <- read_fwf("train/x_train.txt", fwf_widths(rep(16, times=561), col_names=features$featurename))
x_train <- x_train[,grep("mean|std", features$featurename)]
x_train$rownumber <- 1:nrow(x_train)

#x_train$traintrain <- "train"

y_train <- read_tsv("train/y_train.txt", col_names="activityid")
y_train$rownumber <- 1:nrow(y_train)
y_train$testtrain <- "train"
y_train <- y_train %>% left_join(subjects_train, by=c("rownumber" = "rownumber"))
y_train <- y_train %>% left_join(activities, by=c("activityid" = "activityid"))

all_train <- left_join(y_train, x_train, by = c("rownumber" = "rownumber"))

## append the two data tables into one big dataset.

all_data <- rbind(all_test, all_train)

## Use the group by and summarize_each functions to build the summary table
all_summary <- all_data %>% group_by(subjectid, activityname) %>% summarize_each(funs(mean), 6:ncol(all_data))

