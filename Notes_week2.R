##_______________________________________________________________________________________________________##
##
##
##
##  Project Name :Getting and cleaning data
##  Developer Name : Aurore Paligot
##  
##  Script Name : Notes_week2
##  Description : My personal notes for the Coursera "getting and cleaning data " course by Johns Hopkins University
##  Current Status : in process
##  History versions : 11-05-2019 : first commit
##
##
##                                                                                                       
##_______________________________________________________________________________________________________##

##----------------------1.MySQL----------------------------------------------------------------------####
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



