##_______________________________________________________________________________________________________##
##
##
##
##  Project Name :Getting and cleaning data
##  Developer Name : Aurore Paligot
##  
##  Script Name : Notes_week2
##  Description : My personal notes for the Coursera "getting and cleaning data " course by Johns Hopkins University
##  Current Status : complete
##  History versions : 11-05-2019 : first commit
##                     21-05-2019 : last commit
##
##
##                                                                                                       
##_______________________________________________________________________________________________________##

##----------------------1. MySQL----------------------------------------------------------------------####
#example with this data base http://genome.ucsc.edu/goldenPath/help/mysql.html
library(RMySQL)

#Connect to the database
ucscDb <- dbConnect(MySQL(),user="genome", 
                    host="genome-mysql.cse.ucsc.edu")

#Apply a querry
result <- dbGetQuery(ucscDb,"show databases;");dbDisconnect(ucscDb);

#Disconecting from the server is really important!

head(result)
# > head(result)
# Database
# 1  acaChl1
# 2  ailMel1
# 3  allMis1
# 4  allSin1
# 5  amaVit1
# 6  anaPla1

#We'll work with one of the databse : hg19
hg19 <- dbConnect(MySQL(),user="genome", 
                  db="hg19", #added db name
                  host="genome-mysql.cse.ucsc.edu")

#List the tables inside of that database
allTables <- dbListTables(hg19)

#how many are there?
length(allTables) #[1] 11141

#list 5 first tables
allTables[1:5]
# [1] "HInv"         "HInvGeneMrna" "acembly"      "acemblyClass" "acemblyPep"  

#focus on one table
dbListFields(hg19,"affyU133Plus2") #columns

# > dbListFields(hg19,"affyU133Plus2")
# [1] "bin"         "matches"     "misMatches"  "repMatches"  "nCount"      "qNumInsert" 
# [7] "qBaseInsert" "tNumInsert"  "tBaseInsert" "strand"      "qName"       "qSize"      
# [13] "qStart"      "qEnd"        "tName"       "tSize"       "tStart"      "tEnd"       
# [19] "blockCount"  "blockSizes"  "qStarts"     "tStarts" 

dbGetQuery(hg19, "select count(*) from affyU133Plus2") #rows

# count(*)
# 1    58463

#Read from the table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

#Select subset of the data
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)

# 0%  25%  50%  75% 100% 
# 1    1    2    2    3 

affyMis2 <- fetch(query)

#Fetch as small part of the data
affyMisSmall <- fetch(query,n=10); dbClearResult(query); #we need to clean the query results
affyMisSmall

#dimension of this new df
dim(affyMisSmall)
# [1] 10 22

#Close connection
dbDisconnect(hg19)





##----------------------2. HDF5 -------------------------------------------------------####

#Install
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")

#Open 
library(rhdf5)

#Create hdf5 file
created = h5createFile("example.h5")
created

#Create groups within the file
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
created = h5createGroup("example.h5","foo/foobaa") #subgroup

#list components of the file
h5ls("example.h5")

#create content inside of the groups
A = matrix(1:10,nr=5,nc=2)
h5write(A, "example.h5","foo/A") #matrix added in a group
B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B, "scale") <- "liter" #metadata added
h5write(B, "example.h5","foo/foobaa/B")

#list the elements 
h5ls("example.h5")

# > h5ls("example.h5")
# group   name       otype  dclass       dim
# 0           /    baa   H5I_GROUP                  
# 1           /    foo   H5I_GROUP                  
# 2        /foo      A H5I_DATASET INTEGER     5 x 2
# 3        /foo foobaa   H5I_GROUP                  
# 4 /foo/foobaa      B H5I_DATASET   FLOAT 5 x 2 x 2

#write a dataframe (top structure)
df = data.frame(1L:5L,seq(0,1,length.out=5),
                c("ab","cde","fghi","a","s"), stringsAsFactors=FALSE)
h5write(df, "example.h5","df")
h5ls("example.h5")

#read the data
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readdf= h5read("example.h5","df")
readA

# > readA
# [,1] [,2]
# [1,]    1    6
# [2,]    2    7
# [3,]    3    8
# [4,]    4    9
# [5,]    5   10

#writing and reading chunks
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
h5read("example.h5","foo/A")

# > h5read("example.h5","foo/A")
# [,1] [,2]
# [1,]   12    6
# [2,]   13    7
# [3,]   14    8
# [4,]    4    9
# [5,]    5   10

h5read("example.h5","foo/A",index=list(1:3,1))

# > h5read("example.h5","foo/A",index=list(1:3,1))
# [,1]
# [1,]   12
# [2,]   13
# [3,]   14



##----------------------3. Reading data from the Web ---------------------------------------------------####

#Create connection with webpage and readlines
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")

#read lines (result as one long line)
htmlCode = readLines(con)

#Closing the connection (super important!)
close(con)

print(htmlCode) #the content comes unstructured

#Parse the data with XML library

library(XML)
library(RCurl) #resolve most problems when connection to the source fail (https)

url <- "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&amp;hl=en"
curl_data <- getURL(url)
html <- htmlTreeParse(curl_data, useInternalNodes=T)

xpathSApply(html, "//title", xmlValue)

xpathSApply(html, "//a[@class='gsc_a_ac gs_ibl']", xmlValue)

#Parse with the HTTR package
library(httr); html2 = GET(url) #here, Rcurl not needed

content2 = content(html2,as="text")

parsedHtml = htmlParse(content2,asText=TRUE)

xpathSApply(parsedHtml, "//title", xmlValue)

xpathSApply(parsedHtml, "//a[@class='gsc_a_ac gs_ibl']", xmlValue)


#accessing website with passwords

pg2 = GET("http://httpbin.org/basic-auth/user/passwd", #this is a website created to test the connection
          authenticate("user","passwd"))

pg2

names(pg2)

#Using handles


##----------------------4. Reading from APIs -----------------------------------------------------------####

## Access Twitter

library(rjson)
library(jsonlite)
library(httr)

myapp = oauth_app("twitter",
                  key="xxx",
                  secret="xxx")

sig = sign_oauth1.0(myapp,
                    token = "xxx",
                    token_secret = "xxx")

homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)


json1 = content(homeTL)

json2 = jsonlite::fromJSON(toJSON(json1))

json1[[17]][3]



##----------------------5. Reading from other sources --------------------------------------------------#####

#How to find if a R package exists? "Data storage mechanism R package" on google
#Almost every type of data has a package in R