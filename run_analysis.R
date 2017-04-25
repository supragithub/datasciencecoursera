#################################################################################
#  This is the run_analysis.R script which does the following
#
#  1. Merges the training and the test sets to create one data set.
#  2. Extracts only the measurements on the mean and standard deviation 
#     for each measurement.
#  3. Uses descriptive activity names to name the activities in the data set
#  4. Appropriately labels the data set with descriptive variable names.
#  5. From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.
#
#################################################################################

## read the activity_labels.txt and store in data frame actvt_label

actvt_label <- read.table("./data/UCI/activity_labels.txt")


## read the features.txt and store in data frame feature

feature <- read.table("./data/UCI/features.txt")

## read the subject_test.txt from test folder and store in data frame subj_test
## these are subjects under test category

subj_test <- read.table("./data/UCI/test/subject_test.txt")


## read y_test.txt from test folder and store in data frame y_test
## these are activities for test category

y_test <- read.table("./data/UCI/test/y_test.txt")


## read the X_test.train from test folder and store in data frame X_test
## these are the measurements of the test category

X_test <- read.table("./data/UCI/test/X_test.txt")


## read the subject_train.txt from train folder and store in data frame subj_train
## these are subjects under train category

subj_train <- read.table("./data/UCI/train/subject_train.txt")


## read y_train.txt from traain folder and store in data frame y_train
## these are activities for train category

y_train <- read.table("./data/UCI/train/y_train.txt")


## read the X_train.txt data from test folder and store in data frame X_train
## these are the measurements of the train category

X_train <- read.table("./data/UCI/train/X_train.txt")


## combine the respective subject, activity and measurement data 
## for test to form the test data and store in data frame 'test'

test <- cbind(subj_test, y_test, X_test)


## combine the respective subject, activity and measurement data 
## for train to form the train data and store in data frame 'train'

train <- cbind(subj_train, y_train, X_train)


## merge test and train data to form the complete data set
## and store in 'test train merge' data frame named tt_mrg

tt_mrg <- rbind(test, train)

## with this it achieves objective 1
##  1. Merges the training and the test sets to create one data set.
##  -------------------------------------------------------------------------


## set appropriate variable (column) names for the new merged data set 

names(tt_mrg) <- c("subject", "activity", as.character(feature[,2]))


## with this it achieves objective 4
#  4. Appropriately labels the data set with descriptive variable names.
##  -------------------------------------------------------------------------


## look up the activity labels with the activity codes 
## and populate descriptive activity names

for(i in 1:nrow(tt_mrg)){tt_mrg[i,2] <- as.character(actvt_label[actvt_label[,1] == tt_mrg[i,2],2])}

## with this it achieves objective 3
#  3. Uses descriptive activity names to name the activities in the data set
##  -------------------------------------------------------------------------


## extract only the columns which are mean and standard deviation of the measurements
## use regular expression to identify the columns and store in 
## a new 'test train merged tidy' data frame called tt_mrg_tidy 

tt_mrg_tidy <- tt_mrg[,c(1,2,grep("mean|std", names(tt_mrg)))]

## with this it achieves objective 2
#  2. Extracts only the measurements on the mean and standard deviation 
#     for each measurement.
##  -------------------------------------------------------------------------


## convert the data frame into a data table to perform average on measurements
## and store in the 'test train merged tidy data table' called tt_mrg_tidy_dt

tt_mrg_tidy_dt <- as.data.table(tt_mrg_tidy)


## calculate average of all variables for each activity and each subject
## store it in the 'test train merged tidy average data table' called tt_mrg_tidy_avg_dt

tt_mrg_tidy_avg_dt <- tt_mrg_tidy_dt[, lapply(.SD, mean), by =.(subject, activity)]

## with this it achieves objective 5
#  5. From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.
##  -------------------------------------------------------------------------


## write the test train merged tidy average data table to a file 
## using write.table function

write.table(tt_mrg_tidy_avg_dt, "./data/test_train_avg_tidy_data.txt", row.names = FALSE)

## End of Script