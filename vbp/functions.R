
import_vpg <- function(){
    wd <- getwd()
    path <- "data"
    file <-  "CMS-1607-F Tables 16A and 16B_FY 2015.xlsx"
    file.path <- paste(wd, path, file, sep = "/")
    library(xlsx)
    read.xlsx(file = file.path, sheetIndex = 1, 
                     sheetName = "Table 16B - FY15",
                     startRow = 2,
                     endRow = 3090,
                     stringsAsFactors = F)
}

import_cert_num <- function(){
    wd <- getwd()
    path  <- "data"
    file <- "Medicare_Certification.csv"
    file.path <- paste(wd, path, file, sep = "/")
    read.csv(file = file.path, header = T, stringsAsFactors = F)
}

import_hosp_vbp_tps <- function(){
    wd <- getwd()
    path  <- "data"
    file <- "Hospital_Value-Based_Purchasing__HVBP____Total_Performance_Score.csv"
    file.path <- paste(wd, path, file, sep = "/")
    read.csv(file = file.path, header = T, stringsAsFactors = F)
}



vbp[, 2] <- as.numeric(vbp[, 2])



plot(hist(vbp[, 2]))
