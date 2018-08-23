#rm(list = ls())
# init
library(dplyr)
folder <- "UCI HAR Dataset"
folder_Test <- paste(folder,"/test",sep = "")
folder_Train <- paste(folder,"/train",sep = "")

# read
X_test<-read.table(paste(folder_Test,"/X_test.txt",sep = ""))
X_train<-read.table(paste(folder_Train,"/X_train.txt",sep = ""))
y_test<-read.table(paste(folder_Test,"/y_test.txt",sep = ""))
y_train<-read.table(paste(folder_Train,"/y_train.txt",sep = ""))
sub_test<-read.table(paste(folder_Test,"/subject_test.txt",sep = ""))
sub_train<-read.table(paste(folder_Train,"/subject_train.txt",sep = ""))

# assign column names
nm <- read.table(paste(folder,"/features.txt",sep=""))
nm<-nm[[2]]
names(X_train)<-nm
names(X_test)<-nm
names(sub_test)<-"subject"
names(sub_train)<-"subject"

# merge them 
X_test<-cbind(sub_test,X_test)
X_train<-cbind(sub_train,X_train)
X <- rbind(X_test,X_train)
y <- rbind(y_test,y_train)

# "Uses descriptive activity names to name the activities in the data set"
y_vector <- y[[1]]
y_vector[grep("1",y_vector)]<-"WALKING"
y_vector[grep("2",y_vector)]<-"WALKING_UPSTAIRS"
y_vector[grep("3",y_vector)]<-"WALKING_DOWNSTAIRS"
y_vector[grep("4",y_vector)]<-"SITTING"
y_vector[grep("5",y_vector)]<-"STANDING"
y_vector[grep("6",y_vector)]<-"LAYING"

names(y)<-"activity"
y[1]<-y_vector
my_data <- cbind(y,X)

# clear work space
rm(sub_test,sub_train,X_test,X_train,y_test,y_train,X,y,nm)

# subset the data whose column names contain "mean" or "std"
# don't forget the "subject" and "activity" column
my_data <- my_data[,c(1,2,grep("mean|std",tolower(names(my_data))))]

# use dplyr to create the data set that contains the average of each subject-activity pair
my_data2 <- tbl_df(my_data)
groups <- group_by(my_data2,activity,subject)
my_data_averaged <- summarise_all(groups,mean)

# clear work space
rm(groups,my_data2,folder,folder_Test,folder_Train,y_vector)

# write out
write.table(my_data_averaged,"my_data_averaged.txt",row.name = FALSE)
