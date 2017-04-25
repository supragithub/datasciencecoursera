## This is the read me file for `run_analysis.R` script
Please read this document carefully first to understand the objective of the script and how each objective has been achieved. code snippets have been embedded to help you understand the implementation.

---
####  The objective of the run_analysis.R script is to achieve the following

  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation 
     for each measurement.
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names.
  5. From the data set in step 4, creates a second, independent tidy data set 
     with the average of each variable for each activity and each subject.


#### Merge the test and train data
Read the activity_labels.txt and store in data frame `actvt_label`

`actvt_label <- read.table("./data/UCI/activity_labels.txt")`


Read the features.txt and store in data frame `feature`

`feature <- read.table("./data/UCI/features.txt")`

Read the subject_test.txt from test folder and store in data frame `subj_test`, These are subjects under test category

`subj_test <- read.table("./data/UCI/test/subject_test.txt")`


Read y_test.txt from test folder and store in data frame `y_test`. 
These are activities for test category

`y_test <- read.table("./data/UCI/test/y_test.txt")`


Read the X_test.train from test folder and store in data frame `X_test`
These are the measurements of the test category

`X_test <- read.table("./data/UCI/test/X_test.txt")`


Read the subject_train.txt from train folder and store in data frame `subj_train` These are subjects under train category

`subj_train <- read.table("./data/UCI/train/subject_train.txt")`


Read y_train.txt from traain folder and store in data frame `y_train`. These are activities for train category

`y_train <- read.table("./data/UCI/train/y_train.txt")`


Read the X_train.txt data from test folder and store in data frame `X_train`. These are the measurements of the train category

`X_train <- read.table("./data/UCI/train/X_train.txt")`


combine the respective subject, activity and measurement data for test to form the test data and store in data frame `test`

`test <- cbind(subj_test, y_test, X_test)`


Combine the respective subject, activity and measurement data for train to form the train data and store in data frame `train`

`train <- cbind(subj_train, y_train, X_train)`


merge test and train data to form the complete data set and store in 'test train merge' data frame named `tt_mrg`

`tt_mrg <- rbind(test, train)`

#### with this it achieves objective 1
*Merges the training and the test sets to create one data set.*

---

#### Name the variables appropriately

set appropriate variable (column) names for the new merged data set 

`names(tt_mrg) <- c("subject", "activity", as.character(feature[,2]))`


#### With this it achieves objective 4
*Appropriately labels the data set with descriptive variable names.*

---

#### Populate descriptive activity names

Look up the activity labels with the activity codes and populate descriptive activity names

`for(i in 1:nrow(tt_mrg)){tt_mrg[i,2] <- as.character(actvt_label[actvt_label[,1] == tt_mrg[i,2],2])}`

Since in the activity label data set the activity ids and the row indices are the same, this could be achieved easily using vector operation. But it would not work if the activity ids do not correspond to the row indices. However the above implementation will work even if for a data file where the activity ids are different from the row indices.

#### with this it achieves objective 3
*Uses descriptive activity names to name the activities in the data set*

---

#### Extract the means and standard deviations

extract only the columns which are mean and standard deviation of the measurements. Use regular expression to identify the columns and store in a new 'test train merged tidy' data frame called `tt_mrg_tidy `

`tt_mrg_tidy <- tt_mrg[,c(1,2,grep("mean|std", names(tt_mrg)))]`

#### with this it achieves objective 2
*Extracts only the measurements on the mean and standard deviation for each measurement.*

---

#### Calculate Average of all variables for each activity and each subject

Convert the data frame into a data table to perform average on measurements and store in the 'test train merged tidy data table' called `tt_mrg_tidy_dt`

`tt_mrg_tidy_dt <- as.data.table(tt_mrg_tidy)`


Calculate average of all variables for each activity and each subject store it in the 'test train merged tidy average data table' called `tt_mrg_tidy_avg_dt`
This requires package **data.table**. `install.packages(data.table)` and `library(data.table)` commands have been used to make the package available. 

`tt_mrg_tidy_avg_dt <- tt_mrg_tidy_dt[, lapply(.SD, mean), by =.(subject, activity)]`

#### with this it achieves objective 5
*From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.*

---

#### Write output to a file
Write the test train merged tidy average data table to a file using `write.table()` function

`write.table(tt_mrg_tidy_avg_dt, "./data/test_train_avg_tidy_data.txt", row.names = FALSE)`

---
End of document