#find the url address
url <- "https://kaiserhealthnews.files.wordpress.com/2016/08/readmission_five_years_chart_withlink.csv"
destfile <- "./data_raw/readmit.csv"
if(!file.exists(destfile)){
        download.file(url = url, destfile = destfile, method = "curl")
}

#read in the file
df <- read.csv("./data_raw/readmit.csv", header = T, stringsAsFactors = F, skip = 6)
#plot missing data
file <- "./plots/Missing_Data_by_Variable_Readmission_Amelia.pdf"
pdf(file = file, width = 8, height = 5)
library(Amelia)
missmap(df)
dev.off()
#plot missing data another way
df.missing <- data.frame(apply(df, 2, function(x) sum(is.na(x))))
names(df.missing)[1] <- "missing"
df.missing$variables <- row.names(df.missing)

p <- ggplot(df.missing, aes(x = as.factor(variables), missing))
p <- p + geom_point()
p
p <- p + ggtitle("Missing Data by Variable in Readmission Data")
p <- p + theme(plot.title = element_text(hjust = 0.5))
p
file <- "./plots/Missing_Data_by_Variable_Readmission_Data.pdf"
ggsave(filename = file, height = 5, width = 8, unit = "in")

####Take data frame from wide to long
library(dplyr)
library(tidyr)
df.long <- 
        df %>%
        gather(key = year, value = value, -Hospital.Name, -City, -State, -No..Yrs.Penalized)

head(df.long)

#Clean up "FY" in year column
df.long$year <- gsub("\\.", "", df.long$year)
df.long$year <- gsub("FY", "", df.long$year)
df.long$year <- as.integer(df.long$year)
print(paste("There are", sum(is.na(df.long)), "missing values.", sep = " "))
df.long <- na.omit(df.long)
print(paste("There are", sum(is.na(df.long)), "missing values.", sep = " "))
head(df.long)

#change variable name
names(df.long)[grep("No\\.\\.", names(df.long))] <- "Yrs.Penalized"

#write it out
file <- "./data_tidy/2016_readmission_penalties_all_hosp_five_years.csv"
write.csv(df.long, file = file, row.names = F)
rm(list = ls())
