#### NOAA API ####

#### library needed (if don't have, use install.packages("") to install them)
# install.packages("dplyr")

library(httr)
library(jsonlite)
library(magrittr)
library(plyr)
library(dplyr)

baseURL <- "https://www.ncdc.noaa.gov/cdo-web/api/v2/"
token <- "EtompFHtxhulwEcUWikdjlkUZwhicGib"

target <- "datasets"
queryItem <- list(startdate="2019-06-18")

datPul <- GET(baseURL, path=target, config(token=token), query=queryItem) # ? not know where was wrong..
