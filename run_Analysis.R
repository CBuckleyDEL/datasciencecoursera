library(plyr)

# Merges the training and the test sets to create one data set
xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/y_train.txt")
subjectTrain <- read.table("train/subject_train.txt")

xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/y_test.txt")
subjectTest <- read.table("test/subject_test.txt")

# Create new data sets
xData <- rbind(xTrain, xTest)
yData <- rbind(yTrain, yTest)
joinedData <- rbind(subjectTrain, subjectTest)


# Extracts only the measurements on the mean and standard deviation for each measurement 
features <- read.table("features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
xData <- xData[, mean_and_std_features]
names(xData) <- features[mean_and_std_features, 2]

# Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
yData[, 1] <- activities[yData[, 1], 2]
names(yData) <- "activity"

# Appropriately label the data set with descriptive variable names
names(joinedData) <- "subject"
allData <- cbind(xData, yData, joinedData)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
averagesData <- ddply(allData, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averagesData, "averages_data.txt", row.name=FALSE)
