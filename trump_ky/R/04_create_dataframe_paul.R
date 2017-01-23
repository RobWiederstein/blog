#read in Trump data frame
trump <- read.csv("./data_tidy/ky_trump_2016.csv", header = T, stringsAsFactors = F)

#fit linear model to Trump
fit.lm <- lm(tr_pct ~ per_capita_income + pop_dens + pct_bachelor_deg + 
                     coal_2015_pct_chg + pop_2015 + pct_reg_repubs +
                     pct_reg_males + pct_65_and_older + pct_non_white, data = trump)

summary(fit.lm)

#get Jim Gray Results by County
#Variable 1--Trump Winning percentage--Outcome Variable
#load secretary of state general election results Nov 2016.  
file <- "./data_raw/2016_11_08_paul_results.csv"
paul <- read.csv(file = file, header = T, stringsAsFactors = F, nrows = 120)
paul$paul_pct <- round((paul$Paul / paul$Total) * 100, 4)

#build data frame for paul
library(magrittr)
library(dplyr)
df.paul <- trump %>%
        select(County, per_capita_income, pop_dens, pop_2015, pct_bachelor_deg,
               pct_reg_repubs, pct_reg_males, pct_65_and_older, log_pop_2015,
               coal_2015_pct_chg, region, senate_dist, pct_non_white)
df.paul <- cbind(paul$Total, paul$paul_pct, df.paul)
names(df.paul)[grep("Total", names(df.paul))] <- "tot_votes"
names(df.paul)[grep("paul_pct", names(df.paul))] <- "paul_pct"

#add outcome variable
df.paul$outcome <- "w"
counties.lost <- df.paul[which(df.paul$paul_pct < .5) == T, ]
#fit linear model to Paul
fit.lm <- lm(paul_pct ~ per_capita_income + pop_dens + pct_bachelor_deg + 
                     coal_2015_pct_chg + pop_2015 + pct_reg_repubs +
                     pct_reg_males + pct_65_and_older + pct_non_white, data = df.paul)
summary(fit.lm)
df.paul$fitted <- fit.lm$fitted.values
df.paul$resids <- fit.lm$residuals

write.csv(df.paul, file = "./data_tidy/ky_paul_2016.csv", row.names = F)
