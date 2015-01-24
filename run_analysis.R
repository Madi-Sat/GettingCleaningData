#1-Merges the training and the test sets to create one data set

x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/Y_test.txt")
subject_test<-read.table("./test/subject_test.txt")
x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/Y_train.txt")
subject_train<-read.table("./train/subject_train.txt")
#For not having three "V1" column name
colnames(y_test)<-c("ActivityLabel")
colnames(y_train)<-c("ActivityLabel")
colnames(subject_train)<-c("subject")
colnames(subject_test)<-c("subject")
testData<-cbind(y_test,subject_test,x_test)
trainData<-cbind(y_train,subject_train,x_train)
#Merging two data sets for the test and train cases.Since they have similar columns structure. we can use rbind
Data<-rbind(testData,trainData)

#2-Extracts only the measurements on the mean and standard deviation for each measurement. 
#Finding the name of all columns in x_test and y_train by reading feature.txt
n<-read.table("features.txt")
Names<-n[,2]
#Converting Name from factor to character
Names<-as.character(Names)
#finding all features which have mean in 
IncludeMean<-grepl('mean',Names)
#finding all features that have std in
IncludeStd<-grepl('std',Names)
#finding the index number in vector Names that has mean in
IndexMean<-which(IncludeMean)
#finding the index number in vector Names that has std in
IndexStd<-which(IncludeStd)
#adding 2 to each index because Data has two more columns
IndexMean<-IndexMean+2
IndexStd<-IndexStd+2
#all the indecis have mean or std in its name
Index_Mean_Std<-c(IndexMean,IndexStd)
#to get more tidy data it is better to sort Index_Mean_Std
#Index_Mean_Std<-sort(Index_Mean_Std)
#Here is all measurements  on the mean and standard deviation
Data_Mean_Std<-Data[,Index_Mean_Std]
#we can have them seperately as well as follows
DataMean<-Data[,IndexMean]
DataStd<-Data[,IndexStd]

#3-Uses descriptive activity names to name the activities in the data set
activity_labels<-read.table("activity_labels.txt")
colnames(activity_labels)<-c("Labels","Activity")
Activity<-as.character(activity_labels$Activity)
DF<-cbind(Data["ActivityLabel"],Data["subject"],Data_Mean_Std)
#Replacing activitieslebel by descriptive activity
for (i in 1:length(Activity))
  DF$ActivityLabel[DF$ActivityLabel==activity_labels[i,1]]<-Activity[i]


#4-Appropriately labels the data set with descriptive variable names.
#finding the column name for that has mean 
IncludeMean<-Names[grepl('mean',Names)]
#finding the column name for that has std 
IncludeStd<-Names[grepl('std',Names)]
#name the columns of the Data
colnames(DF)<-c("ActivityLabel","subject",IncludeMean,IncludeStd)


#5-From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
FinalData<-ddply(DF,.(ActivityLabel,subject),numcolwise(mean))
