Notes - Week 1
================
Aurore Paligot

Packages needed:

``` r
library(RCurl)
library(openxlsx)
library(XML)
```

Download a file from the web
----------------------------

We will download a data file from the [Baltimore Data](https://data.baltimorecity.gov/Transportation/Baltimore-Fixed-Speed-Cameras/dz54-2aru) page using the `download.file ()` function.

``` r
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

download.file(fileURL,
              destfile = "Data/cameras.csv", 
              method = "libcurl",
              mode = "wb") #for binary files
```
