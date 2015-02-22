
path<-file.path("UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
##Read Files
dataActivity1<-read.table(file.path(files,"test","Y_test.txt"),header=FALSE)
dataActivity2<-read.table(file.path(files,"train","Y_train.txt"),header=FALSE)
dataSubject1<-read.table(file.path(files,"test","subject_test.txt"),header=FALSE)
dataSubject2<-read.table(file.path(files,"train","subject_train.txt"),header=FALSE)
dataFeatures1<-read.table(file.path(files,"test","X_test.txt"),header=FALSE)
dataFeatures2<-read.table(file.path(files,"train","X_train.txt"),header=FALSE)


##Internal structure of each function
str(dataActivity1)
str(dataActivity2)
str(dataSubject1)
str(dataSubject2)
str(dataFeatures1)
str(dataFeatures2)


##Merge data tables
dataActivity<-rbind(dataActivity1,dataActivity2)
dataSubject<-rbind(dataSubject1,dataSubject2)
dataFeatures<-rbind(dataFeatures1,dataFeatures2)

names(dataActivity)<-c("activity")
names(dataSubject)<-c("subject")
dataFeaturesN<-read.table(file.path(files,"features.txt"),head=FALSE)
names(dataFeatures)<-dataFeaturesN$V2

datapreFinal<-cbind(dataActivity,dataSubject)
finalData<-cbind(dataFeatures,datapreFinal)

subdataFeaturesN<-dataFeaturesN$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesN$V2)]
selectedNames<-c(as.character(subdataFeaturesN),"subject","activity")
finalData<-subset(finalData,select=selectedNames)

##name activities into data set
activityNames<-read.table(file.path(files,"activity_labels.txt"),header=FALSE)
head(finalData$activity,30)

##Set activities names
names(finalData)<-gsub("Acc", "Accelerometer", names(finalData))
names(finalData)<-gsub("BodyBody", "Body", names(finalData))
names(finalData)<-gsub("^f", "Frequency", names(finalData))
names(finalData)<-gsub("Gyro", "Gyroscope", names(finalData))
names(finalData)<-gsub("^t", "time", names(finalData))
names(finalData)<-gsub("Mag", "Magnitude", names(finalData))

finalData2<-aggregate(. ~subject + activity, finalData, mean)
finalData2<-finalData2[order(finalData2$activity,finalData2$subject),]
##WRITE FINAL RESULT
write.table(finalData2, file = "finalTidyData.txt",row.name=FALSE)
