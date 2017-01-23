#load libraries
library(dplyr)
library(magrittr)
library(choroplethr)
library(choroplethrMaps)
library(choroplethrAdmin1)
library(ggplot2)
library(scales)
library(plotly)
#library(MASS) blocks "select" command in dplyr
library(caret)

#Variable 1--Trump Winning percentage--Outcome Variable
#load secretary of state general election results Nov 2016.  
file <- "./data_raw/2016_11_08_ky_general.csv"
v <- read.csv(file = file, header = T, stringsAsFactors = F)
v$total <- rowSums(v[, 2:7])
v$tr_pct <- (v$Trump.Pence / v$total) * 100
names(v)[grep("total", names(v))] <- "tot_votes"


#Variable 2--"i"--load bureau of economic analysis per capita income data
file <- "./data_raw/bea_pci_2015.csv"
i <- read.csv(file = file, header = T, stringsAsFactors = F, skip = 4, nrows = 121)
i <- i[-1, ]
i$GeoName <- gsub(", KY", "", i$GeoName)
v <- cbind(v, i$X2015)
names(v)[10] <- "per_capita_income"
v$tr_pct <- round(v$tr_pct, 4)
rm(i)

#Variable 3--"pop_dens"--calculate population density
file <- "./data_raw/ky_area_census.csv"
area <- read.csv(file = file, header = T, as.is = T)
file <- "./data_raw/pop_est_census_ky_2015.csv"
pop  <- read.csv(file = file, header = T, stringsAsFactors = F)
names(pop)[2] <- "pop_2015"
v$pop_dens <- pop$pop_2015 / area$Value

#Variable 4--"pop_2015"
v$pop_2015 <- pop$pop_2015
rm(area, pop)

#Variable 5--"pct_reg_repubs"--voter registration data from secretary of state
file <- "./data_raw/voter_reg_stats_2016_11_15.csv"
regs <- read.csv(file = file, header = T, stringsAsFactors = F)
regs <- regs[2:121, ]
v$pct_reg_repubs <- regs$Rep / regs$Registered

#Variable 6--"pct_reg_males"--percent males registered to vote
v$pct_reg_males  <- regs$Male / regs$Registered
rm(regs)

#Variable 7 --"pct_bachelor_deg"--get educational attainment data from census
file <- "./data_raw/edu_attainment_ky_2013_bachelor.csv"
edu <- read.csv(file = file, header = T, stringsAsFactors = F)
names(edu)[2] <- "pct_bachelor_deg"
v$pct_bachelor_deg <- edu$pct_bachelor_deg
rm(edu)

#Variable 8 --"pct_65_and_older"--Add variable pct of total population by 
#county 65 or older from U.S. Census 2015
url <- "https://www.census.gov/popest/data/counties/asrh/2015/files/CC-EST2015-ALLDATA-21.csv"
destfile <- "./data_raw/CC-EST2015-ALLDATA-21.csv"
if(!file.exists(destfile)){
        download.file(url = url, destfile = destfile)
}
age <- read.csv(file = destfile, header = T, stringsAsFactors = F)
library(magrittr)
library(dplyr)
df.age_65 <- age %>%
        filter(YEAR == 8) %>%              #year 2015
        filter(AGEGRP %in% 14:18) %>%      #65 and older
        select(YEAR, CTYNAME, AGEGRP, TOT_POP) %>%
        group_by(CTYNAME) %>%
        summarize(age65 = sum(TOT_POP))

df.tot <- age %>%
        filter(YEAR == 8) %>%              #year 2015
        filter(AGEGRP == 0) %>%      #total population
        select(YEAR, CTYNAME, AGEGRP, TOT_POP) %>%
        group_by(CTYNAME) %>%
        summarise(all = sum(TOT_POP))
head(df.tot)
df.pct.age65.tot <- cbind(df.tot, df.age_65)
df.pct.age65.tot$pct <- df.pct.age65.tot$age65 / df.pct.age65.tot$all
v <- cbind(v, df.pct.age65.tot$pct)
names(v)[16] <- "pct_65_and_older"
rm(url, df.age_65, df.tot, df.pct.age65.tot, age, destfile)

#Variable 9--"outcome"--win or loss.  Set to factor
#create win/loss variable. Counties greater than 50% = "W" and less
#than 50% = "L".  Set color of points to that column.
#Trump won Franklin County but with 49.5%
v$outcome <- "w"
v$outcome[which(v$tr_pct < 50)] <- "l"
v$outcome[grep("Franklin", v$County)] <- "w" #Franklin County he won a plurality

#Variable 10--"log_pop_2015"--add log of pop_2015
v$log_pop_2015 <- log(v$pop_2015)

#Variable 11--"coal_2015_pct_chg"--Continuous %decline from 2011 to 2015
#add coal production from http://energy.ky.gov/Programs/Pages/data.aspx
file <- "./data_raw/KY_County_Data.csv"
coal <- read.csv(file = file, header = T, stringsAsFactors = F)
df.coal.2015 <- coal %>%
        select(county, year, clpctp) %>%
        filter(year == 2015) %>%
        arrange(county)
df.coal.2011 <- coal %>%
        select(county, year, clpctp) %>%
        filter(year == 2011) %>%
        arrange(county)
df.new <- data.frame(cbind(df.coal.2011, df.coal.2015), stringsAsFactors = F)
df.new$pct_chg <- ((df.new$clpctp.1 - df.new$clpctp) / df.new$clpctp) * 100
df.new$pct_chg <- round(df.new$pct_chg, 2)
df.new$pct_chg[which(is.na(df.new$pct_chg) == T)] <- 0
df.new$pct_chg[which(is.infinite(df.new$pct_chg) == T)] <- 100
v$coal_2015_pct_chg <- df.new$pct_chg
rm(coal, df.coal.2011, df.coal.2015, df.new)

#Variable 12--"region"--add county fips code for choropleth maps
library(choroplethr)
library(choroplethrMaps)
data("county.map") #choropleth pkg
x <- county.map %>%
        dplyr::filter(STATE == 21) %>%
        select(NAME, region) %>%
        distinct(NAME, region) %>%
        arrange(NAME)
v$region <- x$region
rm(county.map, x)

#Variable 13--"senate_dist"
senate_dist <- c("Henderson", "Union", "Webster", "Crittenden", "Caldwell",
                 "Livingston")
v$senate_dist <- "other"
v$senate_dist[which(v$County %in% senate_dist)] <- "fourth"
rm(senate_dist)

#Variable 13.1 "pct_non_whites"
if(!file.exists("./data_raw/race.csv")){source("./R/mung_race.R")}
race <- read.csv("./data_raw/race.csv", header = T, stringsAsFactors = F)
v$pct_non_white <- race$pct_non_white
rm(race)

#cull only new variables
df <- select(v, County, tr_pct, per_capita_income, pop_dens, pop_2015,
             pct_bachelor_deg, pct_reg_repubs, pct_reg_males, pct_65_and_older,
             outcome, log_pop_2015, coal_2015_pct_chg, region, senate_dist, 
             tot_votes, pct_non_white)

#Variable 14--"fitted"

fit.lm <- lm(tr_pct ~ per_capita_income + pop_dens + pct_bachelor_deg + 
                     coal_2015_pct_chg + pop_dens + pct_reg_repubs +
                     pct_reg_males + pct_65_and_older + pct_non_white, data = df)

summary(fit.lm)
df$fitted <- fit.lm$fitted.values

#Variable 15--"resids" or error
df$resids <- fit.lm$residuals

#trim all decimals to four places
df[, c(4,7,8,9,11,12,15,16)] <- round(df[, c(4,7,8,9,11,12,15,16)], 4)

#write the new data frame out to new .csv file
file <- "./data_tidy/ky_trump_2016.csv"
write.csv(df, file = file, row.names = F)

