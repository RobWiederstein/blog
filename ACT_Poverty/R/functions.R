download_saipe_data <- function(urls){
        for (i in 1:length(urls)){
                file.name <- sapply(strsplit(urls[i], split = "/"), tail, 1)
                destfile <- paste("./data_raw", file.name, sep = "/")
                if(!file.exists(destfile)){
                        download.file(url = urls[i], 
                                      destfile = destfile,
                                      method = "curl", 
                                      quiet = TRUE, 
                                      mode = "w",
                                      cacheOK = TRUE
                        )
                }
        }
}

clean_saipe_files <- function(files){
        temp <- NULL
        saipe <- NULL
        for(i in 1:length(files)){
                widths <- c(3, 6, 72, 9, 9, 9, 20) #get from layout
                temp <- read.fwf(file = files[i], 
                                 widths = widths, 
                                 fill = T,
                                 stringsAsFactors = F,
                                 strip.white = T
                )
                saipe <- rbind(saipe, temp)
        }
        names(saipe) <- c("FIPS",
                          "District_ID",
                          "District_Name", 
                          "Tot_Pop", 
                          "Tot_Child_5_to_17", 
                          "Est_Pov_Child_5_to_17",
                          "File_Name_Creation_Date"
        )
        
        saipe$pct <- round(((saipe$Est_Pov_Child_5_to_17 / 
                                     saipe$Tot_Child_5_to_17) * 100), 2)
        #year is messed up
        saipe$sch_Year <- paste(20, substr(saipe$File_Name_Creation_Date,
                                       start = 3, stop = 4), sep = "")
        saipe <- dplyr::select(saipe, sch_Year, District_ID, District_Name, pct)
        names(saipe) <- tolower(gsub("_", "\\.", names(saipe)))
        name  <- paste(paste(range(2013:2014), collapse = "_"), 
                       "saipe.csv", sep = "_"
        )
        file <- paste("./data_tidy", name, sep = "/")
        write.csv(saipe, file = file, )
        saipe
}


get_2015_2016_act <- function(){
        #2015-2016
        act <- read.csv("./data_raw/20152016_KDE_ACT.csv", header = T, stringsAsFactors = F)
        act <- act[act$DISAGG_ORDER == 0 & act$SCH_NAME == "---District Total---", ]
        act <- act[, c(1, 5, 25)]
        act
}

get_2014_2015_act <- function(){
        #2014-2015
        act <- read.csv("./data_raw/20142015_KDE_ACT.csv", header = T, stringsAsFactors = F)
        act <- act[act$DISAGG_ORDER == 0 & act$SCH_NAME == "---District Total---", ]
        act <- act[, c(1, 5, 25)]
        act
}
get_2013_2014_act <- function(){
        #2013-2014
        act <- read.csv("./data_raw/20132014_KDE_ACT.csv", header = T, stringsAsFactors = F)
        act <- act[act$DISAGG_ORDER == 0 & act$SCH_NAME == "---District Total---", ]
        act <- act[, c(1, 5, 25)]
        act
}
get_2012_2013_act <- function(){
        #2012-2013
        act <- read.csv("./data_raw/20122013_KDE_ACT.csv", header = T, stringsAsFactors = F)
        act <- dplyr::filter(act, SCH_NAME == "--- District Total ---" &
                                     DISAGG_ORDER == 0)
        act <- dplyr::select(act, SCH_YEAR, DIST_NAME, COMPOSITE_MEAN_SCORE)
        act
}
clean_act_files <- function(){
        act <- rbind(get_2015_2016_act(),
                     get_2014_2015_act(),
                     get_2013_2014_act(),
                     get_2012_2013_act()
        )
        names(act) <- tolower(gsub("_", "\\.", names(act)))
        act$sch.year <- substr(act$sch.year, start = 5, stop = 8)
        names(act)[2] <- "district.name"
        name <- paste(paste(range(act$sch.year), collapse = "_"), 
                      "kde_act.csv", sep = "_")
        file <- paste("./data_tidy", name, sep = "/")
        write.csv(act, file = file, row.names = F)
        act
}


