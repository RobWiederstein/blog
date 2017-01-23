# load functions for remainder
source("./R/functions.R")

#ky
ky <- c("ky")
county_fips <- get_county_fips(state = ky)
query <- build_query(county_fips)
bea_req_ky <- df_bea_req(query)
#il
il <- "il"
county_fips <- get_county_fips(state = il)
query <- build_query(county_fips)
bea_req_il <- df_bea_req(query)
#in
ind <- "in"
county_fips <- get_county_fips(state = ind)
query <- build_query(county_fips)
bea_req_in <- df_bea_req(query)

#combine and clean
df <- rbind(bea_req_in, bea_req_il, bea_req_ky)
b <- str_split(df$GeoName, pattern = ",")
df$County <- trim(sapply(b, "[", 1))
df$State <- trim(sapply(b, "[", 2))


#reorder columns
df <- df[, c("GeoFips", "County", "State", "Code", "TimePeriod", "CL_UNIT", 
             "UNIT_MULT", "DataValue")]

#write out file
file <- paste(getwd(), "objects/bea_pci.csv", sep = "/")
write.csv(df, file = file)

rm(list = ls())

