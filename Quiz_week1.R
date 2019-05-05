##_______________________________________________________________________________________________________##
##
##
##
##  Project Name :Getting and cleaning data
##  Developer Name : Aurore Paligot
##  
##  Script Name : Quiz_week1
##  Description : My personal notes for the Coursera "getting and cleaning data " course by Johns Hopkins University
##  Current Status : in process
##  History versions : 05-05-2019 : first commit
##
##
##                                                                                                       
##_______________________________________________________________________________________________________##
#load dplyr
library(dplyr)

## Q1 = 53

#read csv 

data <- read.csv("Data/getdata_data_ss06hid.csv")

summary(data$VAL)

sub1 <- filter(data, VAL==24)

##Q3 = 36534720
#read.csv
dat <-  read.csv("Data/Subdata.csv", sep=";")

sum(dat$Zip*dat$Ext,na.rm=T)

dat1 <- complete.cases(dat)

##Q4 = 127
library(XML)
library(RCurl)
library(dplyr)
curlVersion()$features
curlVersion()$protocol

temp <- getURL("http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml")

doc <- xmlTreeParse( temp, useInternalNodes  = TRUE)

rootNode <- xmlRoot(doc)

xmlName(rootNode)

names(rootNode)

rootNode[[1]][[1]][[1]]
rootNode[[1]][[1]]
rootNode[[1]]

xmlApply(rootNode, xmlValue)

zips <- xpathApply( rootNode, "//zipcode", xmlValue )

zip <- as.vector(zips)

zip2 <- zip == "21231"

summary(zip2)

##Q5 = 
library(readr)
library(data.table)

DT <- read.csv("Data/getdata_data_ss06pid.csv")
DT <- fread("Data/getdata_data_ss06pid.csv")
summary(DT)

system.time(mean(DT[DT$SEX==1,]$pwgtp15), mean(DT[DT$SEX==2,]$pwgtp15))
# utilisateur     système      écoulé 
# 0.04        0.00        0.02 

system.time(tapply(DT$pwgtp15,DT$SEX,mean))

# > system.time(tapply(DT$pwgtp15,DT$SEX,mean))
# utilisateur     système      écoulé 
# 0.00        0.00        0.02 

system.time(mean(DT$pwgtp15,by=DT$SEX))
# > system.time(mean(DT$pwgtp15,by=DT$SEX))
# utilisateur     système      écoulé 
# 0           0           0 

system.time(rowMeans(DT[DT$SEX==1]), rowMeans(DT[DT$SEX==2]) )

system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
# utilisateur     système      écoulé 
# 0           0           0 

system.time(DT[,mean(pwgtp15),by=DT$SEX])
# utilisateur     système      écoulé 
# 0.03        0.00        0.01 



