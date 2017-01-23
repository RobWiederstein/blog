bind_years <- function(){
        make_table <- function(file){
                h <- read.csv(file = file,
                              header = F,
                              as.is = T,
                              row.names = NULL,
                              sep = ",",
                              strip.white = T
                )
                h <- h[complete.cases(h), ]
                h <- h[which(h[, 1] != ""), ]
                h <- h[order(h$V1), ]
                year <- substr(file, start = 19, stop = 22)
                h$V13 <- year
                h
        }
        files <- list.files(path = "./data_raw", pattern = "t1", full.names = T)
        hu <- NULL
                for(i in 1:length(files)){
                    hu <- rbind(hu, make_table(files[i]))
                }
        hu
}
a <- bind_years()
#name variables
names <- c(
        "hospital",
        "licensed_acute_beds",
        "licensed_psych_beds",
        "tot_licensed_beds",
        "beds_in_operation",
        "admissions",
        "inpatient_days",
        "discharges",
        "discharge_days",
        "avg_daily_census",
        "avg_length_of_stay",
        "occupancy_pct",
        "year"
)
names(a) <- names
#get rid of commas, percent signs and spaces
for(i in 1:length(a)){
        a[, i] <- gsub(",", "", a[, i])
        a[, i] <- gsub("%", "", a[, i])
        a[, i] <- stringr::str_trim(a[, i], side = c("both"))
}
#uniform observation names (Hardly!)
a$hospital <- tolower(a$hospital)
#convert character to numeric
a[, 2:13] <- apply(a[, 2:13], MARGIN = 2, as.numeric)
a[, 13] <- as.integer(a[, 13])
#wide to long
a <- tidyr::gather(a, variable, value, -hospital, -year)
#save
write.csv(a, "./data_tidy/kyhut1all.csv",
           row.names = F)
rm(list = ls())
