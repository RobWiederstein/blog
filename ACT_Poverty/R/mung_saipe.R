setwd("/Users/robertwiederstein/Dropbox/R-Projects/ACT_Poverty")
url <- "http://www.census.gov/did/www/saipe/downloads/sd13/sd13_KY.txt"
destfile <- "saipe.txt"
download.file(url = url, destfile = destfile , method = "curl", quiet = TRUE, mode = "w",
              cacheOK = TRUE)
widths <- c(3, 6, 72, 9, 9, 9, 20) #get from layout
saipe <- read.fwf(file = destfile, widths = widths, fill = T)


#layout
url <- "http://www.census.gov/did/www/saipe/downloads/sd13/README.txt"
destfile <- "layout.txt"
download.file(url = url, destfile = destfile)
layout <- readLines("layout.txt", skipNul = T)
layout <- layout[-which(layout == "")]
begin <- grep("Position", layout)
end <- length(layout)
layout <- layout[begin : end]
# gave up!
names <- c("FIPS", "District_ID", "District_Name", "Tot_Pop", 
           "Child_5_to_17", "Est_Pov_Child_5_to_17","File_Name_Creation_Date")

#add pct
saipe$pct <- round(((saipe$Est_Pov_Child_5_to_17 / saipe$Tot_Pop) * 100), 2)
saipe$date <- (rep("2013", nrow(saipe)))
save(saipe, file = "mung_saipe")

rm(list = ls())

