The train and test files are first read and then
merged with rbind.

Then, using grepl I was able to identify all
the measurements on the mean and the sd.

To make the file more user-friendly
I first transformed the activity and the
subject codes to factors and with the help
of cbind I bind as a column the 
activities vector to the dataset.

The rest is very similar to what was done before.
