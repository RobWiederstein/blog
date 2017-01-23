#script outline adapted from Mike Silva and his blog at
#https://buddingdatascientist.wordpress.com/2014/04/05/
#pulling-in-bea-api-data-into-r/comment-page-1/#comment-50

# Load the needed libraries
library(RCurl)
library(rjson)
library(reshape2)
library(ggplot2)
library(plyr)
library(dplyr)
library(repmis)
library(stringr)
library(gdata)


# Read in the Federal Information Processing Standards (FIPS) codes 
#for the Metropolitan Statistics Area (MSA)
get_msa_fips <- function(){  
  library(repmis)
  fips_url <- "https://875c43d8e90f1d7765f92b4e8882863dd8e8c2d5.googledrive.com/host/0B9jKAdYAFCl3bk9jODNteXhYbFk/bea_msa_fips.csv"
  fips_msa_bea <- source_data(url = fips_url, header = F, cache = T)
  file <- paste(getwd(), "data/bea_msa_fips.csv", sep = "/")
  write.csv(fips_msa_bea, file = "bea_msa_fips.csv", row.names = T)
  msa = read.csv(file = file, header = TRUE, sep = ",", colClasses = "character" )
  msa <- msa[, -1]
  names(msa) <- c("Name", "FIPS")
  msa <- msa[-1, ]
  msa$FIPS #coming out as character data
}

#Read in the FIPS codes for each KY county from U.S. census
get_county_fips  <- function(state){
  state <- toupper(state)
  library(repmis)
  file <- paste(getwd(), "data/national_county_fips.txt", sep = "/")
  fips <- read.csv(file = file, header = T, sep = ",", colClasses = "character")
  names(fips) <- c("state", "statefp", "countyfp", "countyname", "classfp")
  fips$fips <- with(fips, paste(statefp, countyfp, sep = ""))
  fips <- fips[, c(1, 4, 6)]
  fips <- fips[fips$state %in% state, ]
  fips <- fips$fips
  fips
}

#build json request per BEA guidelines.  Guide available online
#at http://www.bea.gov/api/docs/index.htm
# API key sent via separate email
build_query <- function(fips){
  bea.api.url <- "http://www.bea.gov/api/data/"
  bea.api.key <- "?UserID=04737E8F-9747-4CF5-BBB9-E56297927619"
  method <- "&method=GetData"
  data.set <- "&datasetname=RegionalData"
  key.code <- "&KeyCode=PCPI_CI"
  geo.fips <- "&GeoFIPS="
  format <- "&ResultFormt=json"
  paste(bea.api.url,
        bea.api.key,
        method,
        data.set,
        key.code,
        geo.fips,
        fips,       #along fips csv
        format,
        sep = ""
        )
}

df_bea_req <- function(request){
  fips <- request
  library(RCurl)
  library(rjson)
  df <- NULL
  df <- data.frame(df, stringsAsFactors = F)
  a <- getURL(fips)
  #length(fips)
  for (i in 1:length(fips)){
    a.1 <- fromJSON(a[i])
    a.1 <- a.1$BEAAPI$Results$Data
    a.2 <- ldply(a.1, data.frame, stringsAsFactors = F)
    df <- rbind(df, a.2)
  }
  df
}

clean_df_bea <- function(df){
  b <- str_split(df$GeoName, pattern = ",")
  df$County <- trim(sapply(b, "[", 1))
  df$State <- trim(sapply(b, "[", 2))
  df <- df[, c(df$GeoFips, df$County, df$State, df$Code, df$TimePeriod, df$CL_UNIT, 
               df$UNIT_MULT, df$DataValue)]
  df
}
