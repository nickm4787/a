
##Step 1: Merges the training and the test sets to create one data set.
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/Y_train.txt")
strain <- read.table("train/subject_train.txt")

xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/Y_test.txt")
stest <- read.table("test/subject_test.txt")

names(strain) <- "Subject"
names(stest) <- "Subject"
names(ytrain) <- "Activity"
names(ytest)  <- "Activity"

features <- read.table("features.txt")
names(xtrain) <- features$V2
names(xtest) <- features$V2

train <- cbind(strain, ytrain, xtrain)
test <- cbind(stest, ytest, xtest)
combined <- rbind(train, test)

##Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
selectcols <- grepl("mean()", names(combined)) | grepl("std()", names(combined))
selectcols[1:2] <- TRUE
combined <- combined[, selectcols]

##Step 3: Uses descriptive activity names to name the activities in the data set
actLabel <- read.table("activity_labels.txt")
actLabel$V2 <- as.character(actLabel$V2)
act <- as.list(actLabel$V2)
combined$Activity <- factor(combined$Activity, labels=act)

##Step 4: Appropriately labels the data set with descriptive variable names.
##Descriptions of variables were added in Step 1

##Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
meltcombined <- melt(combined, id=c("Subject", "Activity"))
tidycombined <- dcast(meltcombined, Subject+Activity ~ variable,mean)
write.table(tidycombined, "tidydata.txt", row.name=FALSE)
