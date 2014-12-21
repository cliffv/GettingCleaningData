## Assignment: Getting and Cleaning Data
## Cliff Voetelink

setwd("./GettingandCleaningData/Assignment/")

filePathTrain   <- "./UCI HAR Dataset/train/"
filePathTest    <- "./UCI HAR Dataset/test/"

# First join the training set with the corresponding labels and subject ids
# We label the training labels as "activity_type" and the subjects as "subject" as their current label V1 is already used in X_train.txt

dfXtrain                <- read.table(paste0(filePathTrain,"X_train.txt"))
dfX_train_label         <- read.table(paste0(filePathTrain,"y_train.txt"), col.names = c("activity_type"))
dfX_train_subject       <- read.table(paste0(filePathTrain,"subject_train.txt"), col.names = c("subject"))

dfTrain                 <- cbind(dfXtrain, dfX_train_label, dfX_train_subject)

#str(dfTrain) 
dim(dfTrain)

# Do the same but for testing set 

dfXtest                 <- read.table(paste0(filePathTest,"X_test.txt"))
dfX_test_label          <- read.table(paste0(filePathTest,"y_test.txt"), col.names = c("activity_type"))
dfX_test_subject        <- read.table(paste0(filePathTest,"subject_test.txt"), col.names = c("subject"))

dfTest                  <- cbind(dfXtest, dfX_test_label, dfX_test_subject)

#str(dfTest) 
dim(dfTest)

# Put the constructed training and test data together into 1 dataset
# Will contain original X data, labels and subject a in that order

dfJoinedData <- rbind(dfTrain, dfTest)
dim(dfJoinedData) # 10299 x 563

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## This includes means and standard deviations with respect to everything including frequencies, and angles that are based on means. 
# I decided to include those as they can always be removed later on in the process should we decide not to use them.

filePathMain    <- "./UCI HAR Dataset/"
dfFeatures      <- read.table(paste0(filePathMain,"features.txt"))
dim(dfFeatures) # 561 x 2

vFeatIndexRelevant <- grep("(mean\\(\\))|(std\\(\\))|[Mm]eanFreq\\(\\)", dfFeatures$V2)

#Give names to the relevant features in our dataset
colnames(dfJoinedData)[vFeatIndexRelevant] <- as.character(dfFeatures[vFeatIndexRelevant,2])

#As we also would like to keep the labels and subjects , we create a new vector specifiying all indexes we need
vRelevantIndices        <- c(vFeatIndexRelevant, dim(dfJoinedData)[2], dim(dfJoinedData)[2]-1)
dfJoinedData            <- dfJoinedData[, vRelevantIndices]

str(dfJoinedData)
dim(dfJoinedData) 


# 3. Uses descriptive activity names to name the activities in the data set

dfActivity_type         <- read.table(paste0(filePathMain,"activity_labels.txt"), col.names = c("activity_type", "activity"))
dfJoinedData            <- merge(dfJoinedData, dfActivity_type, by.x="activity_type", by.y="activity_type", all.x=TRUE)

#replace underscores by "-", turn to lower case and turn it into a factor
dfJoinedData$activity   <- gsub("_","-", dfJoinedData$activity)
dfJoinedData$activity   <- tolower(dfJoinedData$activity)
dfJoinedData$activity   <- as.factor(dfJoinedData$activity)
summary(dfJoinedData$activity)

#remove the old label as it is not descriptive. We will use the activity as a label.
dfJoinedData$activity_type <- NULL #new label is activity


# 4. Appropriately labels the data set with descriptive variable names. 
# We use the previously assigned names (from step 1) as they are already descriptive (instead of V1, V2 etc.) and tells us what the numbers mean. 
# We make slight modifications to the the names. 

# The names are already descriptive due to the following:
# We have the first letter that describes whether it was time data or fast fourier transformed data
# We then have what it is measuring and if it is done by the accelerometer or gyorscope: bodyacc (body accelator , bodygyro) etc.
# We have the type of statistic of measure, it can either be a mean or std (standard deviation)
# The last (optional) part refers to the direction (x, y, z coordinates) of the measurement

# Due to the fact that variable names are already quite long, we choose not to edit some of the abbreviations like
# 't' and 'f' which could be replaced for 'time' and 'fft' to make it even more descriptive.

names(dfJoinedData)     <- tolower(names(dfJoinedData)) #to lower case
names(dfJoinedData)     <- gsub("\\(\\)", "", names(dfJoinedData)) #remove "()"
names(dfJoinedData)     <- gsub("_", "-", names(dfJoinedData)) #replace "_" by "-"
names(dfJoinedData)     <- gsub("bodybody", "body", names(dfJoinedData)) #replace "bodybody" by "body", no duplicates
names(dfJoinedData)     <- gsub("\\(", "-", names(dfJoinedData)) #replace "(" by "-", 
names(dfJoinedData)     <- gsub("\\)", "-", names(dfJoinedData)) #replace ")" by "-"
names(dfJoinedData)     <- gsub("\\,g)", "g", names(dfJoinedData)) #replace ",g" by g"

# We have now constructed a tidyset as:
#- each variable we measure is in 1 column (was already the case)
#- each different observation is in a different row
#- there is 1 table for each type of variable 

dfTidyData <- dfJoinedData
dim(dfTidyData)

write.table(dfTidyData, file = paste0(filePathMain,"tidyDataset1.txt"), row.name=FALSE)


#5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

dfOldTidy <- dfTidyData
dfNewTidy <- data.frame(matrix(ncol = dim(dfOldTidy)[2], nrow = 180))

nofColumns      <- dim(dfOldTidy)[2]
vUniqueActivities <- unique(dfOldTidy$activity)

k <- 0
     
        for (i in 1:30){
              
                
                for (j in vUniqueActivities){
                        
                        k <- k + 1                        
                        
                        vRelevantRows                   <- which(dfOldTidy$subject == i & dfOldTidy$activity == as.character(j))
                        dfNewTidy[k,nofColumns]         <- j
                        dfNewTidy[k,nofColumns-1]       <- i
                        dfNewTidy[k,(1:(nofColumns-2))] <- colSums(dfOldTidy[vRelevantRows, (1:(nofColumns-2))]) / length(vRelevantRows)                
                        #print(dfNewTidy[k,(1:5)])
                }
       
        
        }
                                 
names(dfNewTidy)[1:(nofColumns-2)]              <- paste0("mean-of-", names(dfOldTidy)[1:(nofColumns-2)])
names(dfNewTidy)[(nofColumns-1):nofColumns]     <- names(dfOldTidy)[(nofColumns-1):nofColumns]

write.table(dfNewTidy, file = paste0(filePathMain,"tidyMeans.txt"), row.name=FALSE)

   
