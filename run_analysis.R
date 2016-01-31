##You should create one R script called run_analysis.R that does the following.

##1-Merges the training and the test sets to create one data set.


        ## Reading Sets
        
        TestSet<-read.fwf("./UCI HAR Dataset/test/X_test.txt",widths=rep.int(16,561))
        TrainSet<-read.fwf("./UCI HAR Dataset/train/X_train.txt",widths=rep.int(16,561))



        # Reading Test and Train Subjects and putting all it in an unique dataset with
        # one column called "subject"
        
        SubjectTest<-read.table("./UCI HAR Dataset/test/subject_test.txt")
        SubjectTrain<-read.table("./UCI HAR Dataset/train/subject_train.txt")
        SubjectSet<-rbind(SubjectTest,SubjectTrain)
        names(SubjectSet)<-"subject"



        # Reading Test and Train Labels and naming the colomns "TestLabel" 
        # and "TrainLabel" for each data set
        
        TestLabels<-read.fwf("./UCI HAR Dataset/test/y_test.txt",widths=1)
        names(TestLabels)<-"TestLabel"
        
        TrainLabels<-read.fwf("./UCI HAR Dataset/train/y_train.txt",widths=1)
        names(TrainLabels)<-"TrainLabel"
        
        
        # Reading Features 
        Features<-read.table("./UCI HAR Dataset/features.txt", sep=" ")
        
        
        # Reading Activity Labels and naming its columns
        ActivityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt", sep=" ") 
        names(ActivityLabels)<-c("Label","Activity")
        
        
        
        # Creating new data frames including Test and Train datas with their Test Labels
        Test<-cbind(TestLabels,TestSet)
        Train<-cbind(TrainLabels,TrainSet)
        
        # Naming each data set from the last step
        names(Test)<-c("Activity_ID",as.character(Features$V2))
        names(Train)<-c("Activity_ID",as.character(Features$V2))
        
        # RowBinding Test and Traing to create an unique DataSet 
        DataSet<-rbind(Test,Train)
        
        
        # ColumnBinding SubjectSet and DataSet to have an final DataSet including all 
        # needed data
        
        DataSet<-cbind(SubjectSet,DataSet)
       

        

#2-Extracts only the measurements on the mean and standard deviations for each measurement.
        
        # Using grep to find the variables tha contain mean an standar deviation
        
        
        DataSet<-DataSet[ ,sort(c(1,2,grep("mean",names(DataSet)), grep("std",names(DataSet))))]
        ##DataSet<-DataSet[ ,sort(c(1,2,grep("mean\\()",names(DataSet)), grep("std\\()",names(DataSet))))]
        


#3.Uses descriptive activity names to name the activities in the data set

        #Merging ActivityLabels to change Activity_ID for Activity names
        
        ActivityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt", sep=" ") 
        names(ActivityLabels)<-c("Label","Activity")
        ActivityLabels[,2]<-as.character(ActivityLabels[,2])
        DataSet<-select(.data = merge.data.frame(ActivityLabels,DataSet, by.x = "Label", by.y = "Activity_ID"), -Label)
        


#4.Appropriately labels the data set with descriptive variable names.

        
        NAMES<-gsub("-"," ",names(DataSet))
        NAMES<-gsub("_"," ",NAMES)
        NAMES<-sub("\\()","",NAMES)
        NAMES<-gsub("Freq"," Frequency ",NAMES)
        NAMES<-gsub("Body"," Body ",NAMES)
        NAMES<-gsub("mean"," Mean " ,NAMES)
        NAMES<-gsub("Mag"," Magnitude ", NAMES)
        NAMES<-gsub("^f"," Frequency ",NAMES)
        NAMES<-gsub("^t"," Time ",NAMES)
        NAMES<-gsub("Acc"," Acelerometer ", NAMES)
        NAMES<-gsub("Gyro"," Gyroscope ", NAMES)
        NAMES<-gsub("std"," Standar Deviation",NAMES)
        NAMES<-gsub("Jerk"," Jerk ",NAMES)
        NAMES<-gsub("   ","  ",NAMES)
        NAMES<-gsub("  "," ",NAMES)
        NAMES<-gsub("^ ","",NAMES)
        names(DataSet)<-NAMES

#5.From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
      
        AG<-DataSet %>% group_by(Activity, subject) %>% summarise_each(funs (mean))
        write.table(AG,file = "./Data.txt")
        
        



