
#1----Merges the training and the test sets to create one data set.------

train_x <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
train_y <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
trainsub <- read.table("./UCI_HAR_Dataset/train/subject_train.txt") 

xtest <- read.table("./UCI_HAR_Dataset/test/x_test.txt")        
ytest <- read.table("./UCI_HAR_Dataset/test/y_test.txt")         
testsub <- read.table("./UCI_HAR_Dataset/test/subject_test.txt") 

all_x<- rbind(xtest,train_x)
all_y <- rbind(ytest,train_y)
all_sub <- rbind(testsub,trainsub)

#2---Extracts only the measurements on the mean and standard deviation for each measurement. -----
  
features  <- read.table("./UCI_HAR_Dataset/features.txt")

#find all the std and mean in the file

mean_and_std  <- grepl("(-std\\(\\)|-mean\\(\\))",features$V2)

# remove columns that are not means or std. deviation features
mean_std_x <- all_x[, which(mean_and_std == TRUE)]


#3----Uses descriptive activity names to name the activities in the data set ----

activities <- read.table("./UCI_HAR_Dataset/activity_labels.txt")
activity <- as.factor(all_y$V1)
levels(activity) <- activities$V2

# transform the subject codes to factors, as they will be used as factors later on.
subject <- as.factor(all_sub$V1)

# bind as a column the allLabels vector to the dataset
mean_std_x <- cbind(subject,activity,mean_std_x)


# 4. -- Appropriately label the data set with descriptive variable names.  In this step, the
#       mean and standard deviation feature names are cleaned of hyphens and parentheses, and 
#       then attached as column names to the data set.


filteredfeatures <- (cbind(features,mean_and_std)[mean_and_std==TRUE,])$V2

# Next, a gsub regular expression replacement is used to clean the parenthesese and hyphens, and
# make the name lowercase. The function cleaner does the cleaning, and sapply is used to apply
# the function to all desired featurenames.
cleaner <- function(features) {
  tolower(gsub("(\\(|\\)|\\-)","",features))
}
filteredfeatures <- sapply(filteredfeatures,cleaner)

# Finally, add the filteredfeature names to the mean_std_x set. 
names(mean_std_x)[3:ncol(mean_std_x)] <- filteredfeatures

# write the final dataset to a CSV file, and as a text file
write.csv(mean_std_x,file="dataset1.csv")
write.table(mean_std_x, "dataset1.txt", sep="\t")

# 5.-- Creates a second, independent tidy data set with the average of each
#      variable for each activity and each subject.  (note:  This is where my comfort level
#      with this class seriously falls apart.)

library(reshape2)

molten <- melt(mean_std_x,id.vars=c("subject","activity"))

# cast the molten data set into a collapsed tidy dataset
tidy <- dcast(molten,subject + activity ~ variable,mean)

# write the dataset to a file
write.table(tidy, "dataset2.txt", sep="\t")

