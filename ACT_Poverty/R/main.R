source("./R/functions.R")

#get Model-based Small Area Income & Poverty Estimates (SAIPE) 
#for School Districts, Counties, and States from Census Bureau.
#Add new years as element one in "urls"

urls <- c(
        "http://www.census.gov/did/www/saipe/downloads/sd14/sd14_KY.txt",
        "http://www.census.gov/did/www/saipe/downloads/sd13/sd13_KY.txt"
)

#Downloads are placed in the directory "./data_raw"
download_saipe_data(urls = urls)

#files converted to long, tidy form and placed in "./data_tidy
files <- list.files(path = "./data_raw", pattern = "sd", full.names = T)
clean_saipe_files(files = files)

#data retrieved from school report cards at 
#https://applications.education.ky.gov/src/DataSets.aspx
# and downloaded into ./data_raw
clean_act_files()

a <- clean_saipe_files(files = files)
a$district.name <- gsub(" School District", "", a$district.name)
b <- clean_act_files()
a <- dplyr::filter(a, sch.year == "2014")
b <- dplyr::filter(b, sch.year == "2016")
df <- merge(a, b,  by = "district.name")
df <- dplyr::select(df, district.name, sch.year.x, sch.year.y, pct,
                    composite.mean.score)
names(df)[5] <- "act"

fit.act <- lm(act ~ pct, data = df)
#On a simple one variable linear model the percentage of children in poverty
#is a statistically signficant at the 1 percent level and explains 22.1% of the 
#variation in act scores. 
summary(fit.act)
#Henderson's pct child poverty is 23.8%.  The linear model estimates with a 90%
#confidence interval that the score would be between 19.36 and 19.68.
#Henderson's score is 19.8, just above the upper boundary.
predict(fit.act, 
        data.frame(pct = c(0, 10, 20, 23.8, 30, 40, 50, 60)), 
        interval = "confidence", 
        level = .90
        )
#Henderson's pct child poverty is 23.8%.  The linear model would predict with 
#a 90% prediction interval that the act score would be between 17.71 and 21.44.
#Henderson's is within the prediction interval at 19.8.
predict(fit.act, 
        data.frame(pct = c(0, 10, 20, 23.8, 30, 40, 50, 60)), 
        interval = "prediction", 
        level = .90
)
confint(fit.act, )
coef(fit.act)
library(ggplot2)
p <- ggplot(df, aes(x = pct, y = act))
p <- p + geom_point()
p <- p + geom_smooth(method = "lm", level = .95)
p <- p + scale_x_continuous(breaks = seq(from = 10, to = 50, by = 5))
p <- p + ggtitle("ACT Scores Adjusted by Pct of Children in Poverty")
p

ind <- grep("Independent", df$district.name)
not.ind <- setdiff(1:nrow(df), ind)
df_1 <- df 
df_1$ind <- ""
df_1$ind[ind] <- "yes"
df_1$ind[not.ind] <- "no"
#df_1$ind <- as.integer(df_1$ind)
df_1$ind <- as.factor(df_1$ind)



fit.lm2 <- lm(form = act ~ pct + I(ind),
             data = df_1)
summary(fit.lm2)
plot(fit.lm2)

predict(fit.lm2, 
        data.frame(pct = 23.8, ind = factor(0)),
        interval = "prediction",
        level = .95
        )
####Plot
library(ggplot2)
p <- ggplot(df_1, aes(x = pct, y = act, colour = ind))
p <- p + geom_point()
p <- p + geom_smooth(method = "lm", level = .95)
p <- p + scale_x_continuous(breaks = seq(from = 10, to = 50, by = 5))
p <- p + ggtitle("2016 Kentucky High School ACT Scores Adjusted for Child Poverty")
#p <- p + annotate("text", x = 12.5, y = 17, 
#                  label = "HC act = 19.8, pct = 23.8")
p
file <- "./plots/2016_act_scores_adjusted_for_child_poverty.pdf"
ggsave(filename = file, units = "in", width = 8, height = 5)


###Plot
df_1$pct_bins <- cut_width(df_1$pct, width = 10)
levels(df_1$pct_bins) <- c("Q1", "Q2", "Q3", "Q4", "Q5")
p <- ggplot(df_1, aes(x = pct_bins, y = act, colour = ind))
p <- p + geom_boxplot()
p <- p + xlab("quintile")
p <- p + ggtitle("2016 Kentucky High School ACT Scores by Child Poverty Quintile")
p
file <- "./plots/2016_act_scores_by_child_poverty_quintile.pdf"
ggsave(filename = file, units = "in", width = 8, height = 5)

###table
outlier <-df_1[df_1$ind == "no" & df_1$pct_bins == "Q2", ]
outlier <- outlier[rev(order(outlier$act)), ]
file <- "./tbls/act_scores_by_pov_quintile.pdf"

