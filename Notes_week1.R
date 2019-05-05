##_______________________________________________________________________________________________________##
##
##
##
##  Project Name :Getting and cleaning data
##  Developer Name : Aurore Paligot
##  
##  Script Name : Notes_week1
##  Description : My personal notes for the Coursera "getting and cleaning data " course by Johns Hopkins University
##  Current Status : in process
##  History versions : 05-05-2019 : first commit
##
##
##                                                                                                       
##_______________________________________________________________________________________________________##

##-------------------------1. DOWNLOADING FILES ---------------------------------------####

## Get/ set working directory

getwd()
setwd()

## There are two ways of setting the directory
## (1) Relative

setwd("./data")
setwd("../") #one level up

##(2) Absolute

setwd("/Users/apaligot/Coursera/")

## Check and create directories to put the data in

file.exists("directoryName")

dir.create("directoryName")

if (! file.exists("data")) {
  dir.create("data")
}

## Getting data from the internet

download.file() #of course can be done by hand, but this helps for reproducibility

fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

download.file(fileURL,
              destfile = "Data/cameras.csv", #be careful not to put / in front of directory to select
              method = "libcurl",
              mode = "wb") #for binary files
