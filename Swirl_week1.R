##_______________________________________________________________________________________________________##
##
##
##
##  Project Name :Getting and cleaning data
##  Developer Name : Aurore Paligot
##  
##  Script Name : Swirl_week3
##  Description : My personal notes for the Coursera "getting and cleaning data " course by Johns Hopkins University
##  Current Status : in process
##  History versions : 05-05-2019 : (1) Manipulating Data with dplyr
##
##
##                                                                                                       
##_______________________________________________________________________________________________________##

#Open swirl package
library(swirl)

install_from_swirl("Getting and Cleaning Data")

##---------------1. Manipulating Data with dplyr---------------------------------####

# One unique aspect of dplyr is that the same set of tools allow you to work with tabular data
# | from a variety of sources, including data frames, data tables, databases and multidimensional
# | arrays.In this lesson, we'll focus on data frames. RStudio maintains one of these so-called 'CRAN mirrors' and they generously make their
# | download logs publicly available (http://cran-logs.rstudio.com/). We'll be working with the
# | log from July 8, 2014, which contains information on roughly 225,000 package downloads.

#create df with tible format
# "The main advantage to using a tbl_df over a regular data
# | frame is the printing."

cran <- tbl_df(mydf)

# plyr supplies five 'verbs' that cover most
# | fundamental data manipulation tasks: select(), filter(), arrange(),
# | mutate(), and summarize()

# > cran
# # A tibble: 225,468 x 11
# X date  time    size r_version r_arch r_os  package version country
# <int> <chr> <chr>  <int> <chr>     <chr>  <chr> <chr>   <chr>   <chr>  
#   1     1 2014~ 00:5~ 8.06e4 3.1.0     x86_64 ming~ htmlto~ 0.2.4   US     
# 2     2 2014~ 00:5~ 3.22e5 3.1.0     x86_64 ming~ tseries 0.10-32 US     
# 3     3 2014~ 00:4~ 7.48e5 3.1.0     x86_64 linu~ party   1.0-15  US     
# 4     4 2014~ 00:4~ 6.06e5 3.1.0     x86_64 linu~ Hmisc   3.14-4  US     
# 5     5 2014~ 00:4~ 7.98e4 3.0.2     x86_64 linu~ digest  0.6.4   CA     
# 6     6 2014~ 00:4~ 7.77e4 3.1.0     x86_64 linu~ random~ 4.6-7   US     
# 7     7 2014~ 00:4~ 3.94e5 3.1.0     x86_64 linu~ plyr    1.8.1   US     
# 8     8 2014~ 00:4~ 2.82e4 3.0.2     x86_64 linu~ whisker 0.3-2   US     
# 9     9 2014~ 00:5~ 5.93e3 NA        NA     NA    Rcpp    0.10.4  CN     
# 10    10 2014~ 00:1~ 2.21e6 3.0.2     x86_64 linu~ hfligh~ 0.1     US     
# # ... with 225,458 more rows, and 1 more variable: ip_id <int>

##---------------1.1. select() ----------------------------------------------------####

#Select column by name. Start with the tbl_df name.

select(cran, ip_id, package, country)

# > select(cran, ip_id, package, country)
# # A tibble: 225,468 x 3
# ip_id package      country
# <int> <chr>        <chr>  
#   1     1 htmltools    US     
# 2     2 tseries      US     
# 3     3 party        US     
# 4     3 Hmisc        US     
# 5     4 digest       CA     
# 6     3 randomForest US  

#Select a sequence of columns

## from left to right
select(cran, r_arch:country)

# A tibble: 225,468 x 5
# r_arch r_os      package      version country
# <chr>  <chr>     <chr>        <chr>   <chr>  
#   1 x86_64 mingw32   htmltools    0.2.4   US     
# 2 x86_64 mingw32   tseries      0.10-32 US     
# 3 x86_64 linux-gnu party        1.0-15  US     
# 4 x86_64 linux-gnu Hmisc        3.14-4  US     
# 5 x86_64 linux-gnu digest       0.6.4   CA 

#From right to left
# A tibble: 225,468 x 5
# country version package      r_os      r_arch
# <chr>   <chr>   <chr>        <chr>     <chr> 
#   1 US      0.2.4   htmltools    mingw32   x86_64
# 2 US      0.10-32 tseries      mingw32   x86_64
# 3 US      1.0-15  party        linux-gnu x86_64
# 4 US      3.14-4  Hmisc        linux-gnu x86_64
# 5 CA      0.6.4   digest       linux-gnu x86_64

#Throw columns away

select(cran, -time)

select(cran,-(X:size))



##---------------1.2. filter() -----------------------------------------------------####

#Select rows

##One condition
filter(cran, package == "swirl")

##Or several conditions, separeted by comma
filter(cran, r_version == "3.1.1", country == "US")
filter(cran, r_version <= "3.0.2", country == "IN")

#EITHER one condition OR another condition are TRUE
filter(cran, country == "US" | country == "IN")

#filter na's out in one variable
filter(cran, !is.na(r_version))





##---------------1.3. arrange() -------------------------------------------------------####

# Sometimes we want to order the rows of a dataset according to the values of
# | a particular variable. This is the job of arrange()

#arrange with one column value
arrange(cran2, ip_id)

# A tibble: 225,468 x 8
# size r_version r_arch r_os         package     version country ip_id
# <int> <chr>     <chr>  <chr>        <chr>       <chr>   <chr>   <int>
#   1  80589 3.1.0     x86_64 mingw32      htmltools   0.2.4   US          1
# 2 180562 3.0.2     x86_64 mingw32      yaml        2.1.13  US          1
# 3 190120 3.1.0     i386   mingw32      babel       0.2-6   US          1
# 4 321767 3.1.0     x86_64 mingw32      tseries     0.10-32 US          2
# 5  52281 3.0.3     x86_64 darwin10.8.0 quadprog    1.5-5   US          2

#Same in descending order
arrange(cran, desc(ip_id))

# A tibble: 225,468 x 11
# X date    time      size r_version r_arch r_os    package  version country ip_id
# <int> <chr>   <chr>    <int> <chr>     <chr>  <chr>   <chr>    <chr>   <chr>   <int>
#   1 225464 2014-0~ 23:43~    5933 NA        NA     NA      CPE      1.4.2   CN      13859
# 2 225424 2014-0~ 23:40~  569241 3.1.0     x86_64 mingw32 multcom~ 0.1-5   US      13858
# 3 225371 2014-0~ 23:25~  228444 3.1.0     x86_64 mingw32 tourr    0.5.3   NZ      13857

#arrange according to the value of multiple variables
#arrange(cran2, package, ip_id) will first arrange by package names
# | (ascending alphabetically), then by ip_id

arrange(cran2, package, ip_id)

# A tibble: 225,468 x 8
# size r_version r_arch r_os         package version country ip_id
# <int> <chr>     <chr>  <chr>        <chr>   <chr>   <chr>   <int>
#   1 71677 3.0.3     x86_64 darwin10.8.0 A3      0.9.2   CN       1003
# 2 71672 3.1.0     x86_64 linux-gnu    A3      0.9.2   US       1015
# 3 71677 3.1.0     x86_64 mingw32      A3      0.9.2   IN       1054
# 4 70438 3.0.1     x86_64 darwin10.8.0 A3      0.9.2   CN       1513
# 5 71677 NA        NA     NA           A3      0.9.2   BR       1526





##---------------1.4. mutate () -----------------------------------------------------####
##create a new variable based on the value of one or more variables
# | already in a dataset

mutate(cran3, size_mb = size / 2^20)

# A tibble: 225,468 x 4
# ip_id package         size size_mb
# <int> <chr>          <int>   <dbl>
#   1     1 htmltools      80589 0.0769 
# 2     2 tseries       321767 0.307  
# 3     3 party         748063 0.713

mutate(cran3, 
       size_mb = size / 2^20, 
       size_gb = size_mb/ 2^10)

# A tibble: 225,468 x 5
# ip_id package         size size_mb    size_gb
# <int> <chr>          <int>   <dbl>      <dbl>
#   1     1 htmltools      80589 0.0769  0.0000751 
# 2     2 tseries       321767 0.307   0.000300  
# 3     3 party         748063 0.713   0.000697  
# 4     3 Hmisc         606104 0.578   0.000564  
# 5     4 digest         79825 0.0761  0.0000743 


##---------------1.5. summarize() -----------------------------------------------------####

summarize(cran, avg_bytes = mean(size))

# summarize() is most useful when working with
# | data that has been grouped by the values of a particular variable (to see on next swirl module)