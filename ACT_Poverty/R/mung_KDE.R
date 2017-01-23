#data retrieved from school report cards at 
#https://applications.education.ky.gov/src/DataSets.aspx
# and downloaded into ./data_raw

get_2015_2016_act <- function(){
        #2015-2016
        act <- read.csv("./data_raw/20152016_KDE_ACT.csv", header = T, stringsAsFactors = F)
        act <- act[act$DISAGG_ORDER == 0 & act$SCH_NAME == "---District Total---", ]
        act <- act[, c(5, 1, 25)]
        act
}

get_2014_2015_act <- function(){
        #2014-2015
        act <- read.csv("./data_raw/20142015_KDE_ACT.csv", header = T, stringsAsFactors = F)
        act <- act[act$DISAGG_ORDER == 0 & act$SCH_NAME == "---District Total---", ]
        act <- act[, c(5, 1, 25)]
        act
}
get_2013_2014_act <- function(){
        #2013-2014
        act <- read.csv("./data_raw/20132014_KDE_ACT.csv", header = T, stringsAsFactors = F)
        act <- act[act$DISAGG_ORDER == 0 & act$SCH_NAME == "---District Total---", ]
        act <- act[, c(5, 1, 25)]
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





