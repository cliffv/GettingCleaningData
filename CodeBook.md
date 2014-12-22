---
title: "Codebook Getting and Cleaning Data"
author: "Cliff Voetelink"
date: "Tuesday, December 02, 2014"
output: html_document
---

## Codebook

The data that was edited here was taken from the following website: 

- [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]. 

It includes information about the units and variable names. The data as given for the for the course has been provided as follows and can be found here:

- [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]

The following steps were taken in order to create the tidy dataset named "tidyDataset1.txt".

### Create one dataset from the training and test datasets.

1. The datasets X\_train.txt, subject\_train.txt and y\_train.txt were read into R. Then the training set X\_train.txt was joined with subject\_train.txt along with the y\_train.txt using column binding in order to construct the full training set. The label of y\_training was renamed from V2 to "activity\_type", the label of subject_training was renamed from V2 to "subject" so that no duplicate labels exist. The resulting set was saved as *dfTraining*.
2. The same was done for X\_test.txt with subject\_test.txt and y_test.txt in order to construct the full testing set. The resulting set was saved as *dfTest*.
3. The training set and testing set were joined into 1 dataset called *dfJoinedData* using rbind(). The resulting dataset contains 10299 rows and 563 columns. For the full attribute list we refer to: features.txt, at the end of the two dataset there are two extra columns: 

        - subject, which contains id of the subject at hand. integer, ranging from 1 to 30.
        - activity_type, which is identifier for the type of movement that the subject is doing when the measurements are done. It holds integer values from 1 to 6.

### Now only use the measurements on the mean and standard deviation for each measurement. 
This includes means and standard deviations with respect to everything including frequencies, and angles that are based on means. I decided to include those as they can always be removed later on in the process should we decide not to use them. This was achieved as follows:

4. The dataset features.txt was read into R and saved as dfFeatures. The indices of all relevant features were saved into the vector: vFeatIndexRelevant. The index was saved if second column matched of dfFeatures matched the pattern  mean\\(\\) or std\\(\\) or [Mm]eanFreq\\(\\).
5. A subset of dfJoinedData was saved under the same name using the indices of vFeatIndexRelevant and the last two columns of dfJoinedData which hold the subject and activity type.
6. For the corresponding selected features the names dfFeatures were assigned as labels in dfJoinedData as they are far more descriptive than V1, V2, ... etc.

### Use descriptive activity names to name the activities in the data set

7. activity\_labels.txt was read into R and saved as a data frame dfActivity\_type using labels activity_type and activity. 
8. dfActivity\_type was merged with dfJoinedData using the activity\_type label.
9. activity_type was removed from dfJoinedData as the variable activity will replace it as it is far more descriptive, instead of integers it describes what the person is doing, e.g., "WALKING" etc.
10. The underscores are replaced by "-" in the labels, labels were converted to lower case and the activity was turned into a factor variable. As activity is one of few variables where we actually edit the values of the data, there resulting values that activity can take are displayed below:

- walking 
- walking-upstairs 
- walking-downstairs 
- sitting  
- standing          
- laying            

### Appropriately labels the data set with descriptive variable names. 

11. As we already assigned descriptive / appropriate labes in step 5 to the dataset variables / features, we do not have V1, V2, ... as labels anymore. The names are descriptive due to the following:

- We have the first letter that describes whether it was time data or fast fourier transformed data
- We then have what it is measuring and if it is done by the accelerometer or gyorscope: bodyacc (body accelator , bodygyro) etc.
- We have the type of statistic of measure, it can either be a mean or std (standard deviation)
- The last (optional) part refers to the direction (x, y, z coordinates) of the measurement


12. We make slight modifications to the the names. Due to the fact that variable names are already quite long, we choose not to edit some of the abbreviations such as

- 't' and 'f' which could be replaced for 'time' and 'fft' to make it even more descriptive.
- We do however make the following cahnges to the labels:

        - put all the variable names to lower case
        - remove "\\(\\)"
        - replace underscores by "-"
        - replace "bodybody" by "body" as it is duplicate
        - replace ", " by "-"
        - replace "\\(" by "-"
        - replace "\\)", by "-"
        - replace "\\,g)" by "g"
        
-  We have now constructed a tidyset as because each variable we measure is in 1 column (was already the case), each different observation is in a different row and there is 1 table for each type of variable. Each row is one measurement of an individual of one activity. The types of data are all the same, they are either means or standard deviations, each attribute has its own column.  

13. We save dfJoinedData into dfTidyData and export it as a textfile called tidyDataset1.txt. The list of variables can be found in Appendix A. 

## From the data set in step 4, we create a second, independent tidy data set with the average of each variable per activity per subject.

- As there are 30 subjects and 6 different activities. The resulting dataset will have 6 * 30 = 180 rows. As there 79 variables and 2 identifiers in labeled as activity and subject. The resulting dataset will have 81 columns. 

14. We assign dfOldTidy <- dfTidyData and initialize dfNewTidy as a data frame. 

15. We create double for loop where for each subject i and activity j, we calculate the average per activity per subject for all attributes at once and assign the result this to the next empty row in dfNewTidy. The resulting dataset is dfNewTidy.

16. We assign the same labels to dfNewTidy from dfOldTidy with pre-fix "mean-of-" for indices 1:79 and assign without prefix the identifier labels "activity" and "subject" for indices 80 and 81. The labels are now descriptive.

17. We save dfNewTidy into dfTidyData and export it as a textfile called tidyMeans.txt. Once again it is tidy as it only has averages and only one type of data, namely average attribute value per activity per person where each row respresents one specific of one specific individual. The attributes are distinct and each one has one column. The full list of attributes can be found in Appendix B.

## Appendix A: List of Variables dfTidyData  / tidyDataset1.txt. 
For the full description and for unit description we refer to [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones] and features.txt from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip].

 [1] "tbodyacc-mean-x"      \t\t\t    "tbodyacc-mean-y"      \t\t\t      "tbodyacc-mean-z"          
 [4] "tbodyacc-std-x"       \t\t\t      "tbodyacc-std-y"     \t\t\t        "tbodyacc-std-z"           
 [7] "tgravityacc-mean-x"   \t\t\t      "tgravityacc-mean-y"     \t\t\t    "tgravityacc-mean-z"       
[10] "tgravityacc-std-x"    \t\t\t      "tgravityacc-std-y"    \t\t\t      "tgravityacc-std-z"        
[13] "tbodyaccjerk-mean-x"  \t\t\t      "tbodyaccjerk-mean-y" \t\t\t       "tbodyaccjerk-mean-z"      
[16] "tbodyaccjerk-std-x"   \t\t\t      "tbodyaccjerk-std-y"  \t\t\t       "tbodyaccjerk-std-z"       
[19] "tbodygyro-mean-x"     \t\t\t      "tbodygyro-mean-y"     \t\t\t      "tbodygyro-mean-z"         
[22] "tbodygyro-std-x"      \t\t\t      "tbodygyro-std-y"    \t\t\t        "tbodygyro-std-z"          
[25] "tbodygyrojerk-mean-x" \t\t\t      "tbodygyrojerk-mean-y"   \t\t\t    "tbodygyrojerk-mean-z"     
[28] "tbodygyrojerk-std-x"  \t\t\t      "tbodygyrojerk-std-y"   \t\t\t     "tbodygyrojerk-std-z"      
[31] "tbodyaccmag-mean"     \t\t\t      "tbodyaccmag-std"       \t\t\t     "tgravityaccmag-mean"      
[34] "tgravityaccmag-std"   \t\t\t      "tbodyaccjerkmag-mean"  \t\t\t     "tbodyaccjerkmag-std"      
[37] "tbodygyromag-mean"    \t\t\t      "tbodygyromag-std"      \t\t\t     "tbodygyrojerkmag-mean"    
[40] "tbodygyrojerkmag-std" \t\t\t      "fbodyacc-mean-x"       \t\t\t     "fbodyacc-mean-y"          
[43] "fbodyacc-mean-z"      \t\t\t      "fbodyacc-std-x"        \t\t\t     "fbodyacc-std-y"           
[46] "fbodyacc-std-z"       \t\t\t      "fbodyacc-meanfreq-x"    \t\t\t    "fbodyacc-meanfreq-y"      
[49] "fbodyacc-meanfreq-z"  \t\t\t      "fbodyaccjerk-mean-x"   \t\t\t     "fbodyaccjerk-mean-y"      
[52] "fbodyaccjerk-mean-z"  \t\t\t      "fbodyaccjerk-std-x"    \t\t\t     "fbodyaccjerk-std-y"       
[55] "fbodyaccjerk-std-z"   \t\t\t      "fbodyaccjerk-meanfreq-x"\t\t\t    "fbodyaccjerk-meanfreq-y"  
[58] "fbodyaccjerk-meanfreq-z" \t\t\t   "fbodygyro-mean-x"       \t\t\t    "fbodygyro-mean-y"         
[61] "fbodygyro-mean-z"     \t\t\t      "fbodygyro-std-x"        \t\t\t    "fbodygyro-std-y"          
[64] "fbodygyro-std-z"      \t\t\t      "fbodygyro-meanfreq-x"  \t\t\t     "fbodygyro-meanfreq-y"     
[67] "fbodygyro-meanfreq-z"  \t\t\t     "fbodyaccmag-mean"          "fbodyaccmag-std"          
[70] "fbodyaccmag-meanfreq" \t\t\t      "fbodyaccjerkmag-mean"  \t\t\t     "fbodyaccjerkmag-std"      
[73] "fbodyaccjerkmag-meanfreq" \t\t\t  "fbodygyromag-mean"      \t\t\t    "fbodygyromag-std"         
[76] "fbodygyromag-meanfreq"\t\t\t      "fbodygyrojerkmag-mean"  \t\t\t    "fbodygyrojerkmag-std"     
[79] "fbodygyrojerkmag-meanfreq"\t\t\t  "subject"              \t\t\t      "activity"    

## Appendix B: List of Variables dfNewTidy  /  tidyMeans.txt. 
Contains means of attribute values per activity per subject. For the full description and for unit description we refer to [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones] and features.txt from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]. The difference being that units are now averages per activity for each individual.

names(dfNewTidy)
 [1] "mean-of-tbodyacc-mean-x"     \n    
 "mean-of-tbodyacc-mean-y"          
 [3] "mean-of-tbodyacc-mean-z"     \n    
 "mean-of-tbodyacc-std-x"           
 [5] "mean-of-tbodyacc-std-y"      \n   
 "mean-of-tbodyacc-std-z"           
 [7] "mean-of-tgravityacc-mean-x"   \n   
 "mean-of-tgravityacc-mean-y"       
 [9] "mean-of-tgravityacc-mean-z"  \n    
 "mean-of-tgravityacc-std-x"        
[11] "mean-of-tgravityacc-std-y"    \n   
"mean-of-tgravityacc-std-z"        
[13] "mean-of-tbodyaccjerk-mean-x" \n   
"mean-of-tbodyaccjerk-mean-y"      
[15] "mean-of-tbodyaccjerk-mean-z" \n   
"mean-of-tbodyaccjerk-std-x"       
[17] "mean-of-tbodyaccjerk-std-y"   \n   
"mean-of-tbodyaccjerk-std-z"       
[19] "mean-of-tbodygyro-mean-x"     \n  
"mean-of-tbodygyro-mean-y"         
[21] "mean-of-tbodygyro-mean-z"    \n   
"mean-of-tbodygyro-std-x"          
[23] "mean-of-tbodygyro-std-y"      \n  
"mean-of-tbodygyro-std-z"          
[25] "mean-of-tbodygyrojerk-mean-x" \n    
"mean-of-tbodygyrojerk-mean-y"     
[27] "mean-of-tbodygyrojerk-mean-z"  \n  
"mean-of-tbodygyrojerk-std-x"      
[29] "mean-of-tbodygyrojerk-std-y"  \n   
"mean-of-tbodygyrojerk-std-z"      
[31] "mean-of-tbodyaccmag-mean"     \n   
"mean-of-tbodyaccmag-std"          
[33] "mean-of-tgravityaccmag-mean"  \n   
"mean-of-tgravityaccmag-std"       
[35] "mean-of-tbodyaccjerkmag-mean" \n   
"mean-of-tbodyaccjerkmag-std"      
[37] "mean-of-tbodygyromag-mean"    \n  
"mean-of-tbodygyromag-std"         
[39] "mean-of-tbodygyrojerkmag-mean"\n  
"mean-of-tbodygyrojerkmag-std"     
[41] "mean-of-fbodyacc-mean-x"      \n  
"mean-of-fbodyacc-mean-y"          
[43] "mean-of-fbodyacc-mean-z"       \n  
"mean-of-fbodyacc-std-x"           
[45] "mean-of-fbodyacc-std-y"       \n   
"mean-of-fbodyacc-std-z"           
[47] "mean-of-fbodyacc-meanfreq-x"  \n   
"mean-of-fbodyacc-meanfreq-y"      
[49] "mean-of-fbodyacc-meanfreq-z" \n    
"mean-of-fbodyaccjerk-mean-x"      
[51] "mean-of-fbodyaccjerk-mean-y"  \n   
"mean-of-fbodyaccjerk-mean-z"      
[53] "mean-of-fbodyaccjerk-std-x"   \n  
"mean-of-fbodyaccjerk-std-y"       
[55] "mean-of-fbodyaccjerk-std-z"   \n   
"mean-of-fbodyaccjerk-meanfreq-x"  
[57] "mean-of-fbodyaccjerk-meanfreq-y" \n 
"mean-of-fbodyaccjerk-meanfreq-z"  
[59] "mean-of-fbodygyro-mean-x"    \n     
"mean-of-fbodygyro-mean-y"         
[61] "mean-of-fbodygyro-mean-z"     \n   
"mean-of-fbodygyro-std-x"          
[63] "mean-of-fbodygyro-std-y"       \n  
"mean-of-fbodygyro-std-z"          
[65] "mean-of-fbodygyro-meanfreq-x"  \n   
"mean-of-fbodygyro-meanfreq-y"     
[67] "mean-of-fbodygyro-meanfreq-z"   \n  
"mean-of-fbodyaccmag-mean"         
[69] "mean-of-fbodyaccmag-std"       \n  
"mean-of-fbodyaccmag-meanfreq"     
[71] "mean-of-fbodyaccjerkmag-mean"  \n   
"mean-of-fbodyaccjerkmag-std"      
[73] "mean-of-fbodyaccjerkmag-meanfreq" \n 
"mean-of-fbodygyromag-mean"        
[75] "mean-of-fbodygyromag-std"        \n 
"mean-of-fbodygyromag-meanfreq"    
[77] "mean-of-fbodygyrojerkmag-mean"    \n 
"mean-of-fbodygyrojerkmag-std"     
[79] "mean-of-fbodygyrojerkmag-meanfreq" \n 
"subject"        \n                  
[81] "activity"     